package Fogshare::Worker;
#
# Fogshare - Background Supervisor and Maintenance Worker
#
# Copyright (c) 2026 Fogshare Contributors
# Licensed under the MIT License.
#

use Mojo::Base -strict, -signatures;
use Mojo::JSON   qw(decode_json encode_json);
use File::Basename;
use POSIX        qw(setsid);
use Fcntl        qw(:flock);
use Fogshare::Context qw(
    $BASE_DIR $DIR_STATS $DIR_ACTIVE $DIR_EXPIRED $DIR_TRASH
);

# Maintenance task: aggregate hit statistics and expire depleted/overdue shares
sub run_maintenance_task () {
    return unless -d $DIR_STATS;
    my @state_dirs = ($DIR_ACTIVE, $DIR_EXPIRED, $DIR_TRASH);

    # 1. Process and aggregate incoming hit counters
    $DIR_STATS->list->each(sub {
        my ($file, $idx) = @_;
        return unless $file =~ m{/([^/]+)\.hits$};
        my $slug = $1;

        my $json_file;
        for my $dir (@state_dirs) {
            my $target = $dir->child("$slug.json");
            if (-f $target) {
                $json_file = $target;
                last;
            }
        }

        # Stale hit file without associated share metadata
        unless ($json_file) {
            $file->remove;
            return;
        }

        # Atomically isolate hits using PID and timestamp to avoid race conditions
        my $tmp_file = $DIR_STATS->child("$slug.hits.proc.$$." . time());
        return unless rename($file->to_string, $tmp_file->to_string);

        my $hits_count = 0;
        if (open my $fh, '<', $tmp_file->to_string) {
            $hits_count++ while <$fh>;
            close $fh;
        }
        unlink($tmp_file->to_string);
        return if $hits_count == 0;

        # Atomic write-back to share JSON using exclusive lock
        my $json_path = $json_file->to_string;
        if (open my $jfh, '+<', $json_path) {
            flock($jfh, LOCK_EX);
            my $raw  = do { local $/; <$jfh> };
            my $meta = eval { decode_json($raw) };

            if ($meta) {
                $meta->{views}          = ($meta->{views} // 0) + $hits_count;
                $meta->{last_viewed_at} = time();

                seek($jfh, 0, 0);
                truncate($jfh, 0);
                print $jfh encode_json($meta);
            }

            flock($jfh, LOCK_UN);
            close $jfh;
        }
    });

    # 2. Inspect expiration status based on TTL and view quotas
    my $now = time();
    $DIR_ACTIVE->list->each(sub {
        my ($f, $idx) = @_;
        return unless $f =~ /\.json$/;

        my $meta = eval { decode_json($f->slurp) };
        return unless $meta;

        my $time_exp  = ($meta->{expires_at} > 0 && $now >= $meta->{expires_at});
        my $max_views = int($meta->{max_views} // 0);
        my $quota_exp = (
            $max_views > 0
            && ($meta->{claimed_views} // 0) >= $max_views
            && (!$meta->{expires_at} || $now >= $meta->{expires_at})
        );

        if ($time_exp || $quota_exp) {
            eval { $f->move_to($DIR_EXPIRED->child(basename($f))) };
        }
    });
}

# Daemon initialization: single background supervisor guarded by exclusive non-blocking lock
sub start_singleton_worker () {
    my $lock_file = $BASE_DIR->child('.worker.lock')->to_string;

    open my $lock_fh, '>>', $lock_file or do {
        warn "[Fogshare Worker] Warning: Unable to open lock file $lock_file: $!\n";
        return;
    };

    # Exit gracefully if another worker or supervisor already holds the lock
    unless (flock($lock_fh, LOCK_EX | LOCK_NB)) {
        close $lock_fh;
        return;
    }

    my $pid = fork();
    if (!defined $pid) {
        warn "[Fogshare Worker] Fatal: Failed to fork maintenance supervisor: $!\n";
        flock($lock_fh, LOCK_UN);
        close $lock_fh;
        return;
    }

    # Parent (web application process) continues execution
    return if $pid > 0;

    # --- Background Supervisor Process ---
    $0 = 'fogshare: supervisor';

    if (POSIX->can('setsid')) {
        POSIX::setsid();
        # Reopen standard streams to null devices to decouple from controlling terminal
        open STDIN,  '<', '/dev/null';
        open STDOUT, '>>', '/dev/null';
    }

    $SIG{HUP} = 'IGNORE';

    my $current_child_pid = 0;
    my $shutdown          = 0;

    # Graceful shutdown handler
    $SIG{TERM} = $SIG{INT} = sub {
        $shutdown = 1;
        if ($current_child_pid > 0) {
            kill('TERM', $current_child_pid);
            waitpid($current_child_pid, 0);
        }
        flock($lock_fh, LOCK_UN) if $lock_fh;
        close $lock_fh           if $lock_fh;
        exit 0;
    };

    warn "[Fogshare Worker] Supervisor started (PID: $$), lock acquired.\n";

    # Supervision loop: respawns worker process upon unexpected termination
    while (!$shutdown) {
        my $worker_pid = fork();

        if (!defined $worker_pid) {
            warn "[Fogshare Worker] Fork worker task failed: $!. Retrying in 30s...\n";
            sleep 30;
            next;
        }

        # Child process: periodic maintenance routine
        if ($worker_pid == 0) {
            $0 = 'fogshare: stats & cleaner';
            $SIG{TERM} = $SIG{INT} = 'DEFAULT';

            while (1) {
                my $jitter = 15 + int(rand(30));
                sleep $jitter;

                eval {
                    run_maintenance_task();
                    1;
                } or do {
                    my $err = $@ // 'Unknown error';
                    warn "[Fogshare Worker] Task execution failed: $err\n";
                };
            }
            exit 0;
        }

        # Parent supervisor: monitors worker child process
        $current_child_pid = $worker_pid;
        waitpid($worker_pid, 0);
        my $exit_code = $? >> 8;
        my $signal    = $? & 127;
        $current_child_pid = 0;

        last if $shutdown;

        warn sprintf(
            "[Fogshare Worker] Alert: Worker task (PID %d) exited (Code: %d, Signal: %d). Respawning in 5s...\n",
            $worker_pid, $exit_code, $signal
        );
        sleep 5;
    }

    flock($lock_fh, LOCK_UN) if $lock_fh;
    close $lock_fh           if $lock_fh;
    exit 0;
}

1;