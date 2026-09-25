package Fogshare::Controller::Users;
#
# Fogshare - Administrative User Management Controller
#
# Copyright (c) 2026 Fogshare Contributors
# Licensed under the MIT License.
#

use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::JSON  qw(decode_json encode_json);
use Digest::SHA qw(hmac_sha256_hex);
use Fcntl       qw(:flock);
use Fogshare::Context qw($PASSWD_FILE $SECRET_KEY);

# -----------------------------------------------------------------------------
# User Management Endpoints
# -----------------------------------------------------------------------------

# GET /admin/users
sub list ($c) {
    my $accounts  = $c->load_accounts;
    my @user_list = sort keys %$accounts;

    return $c->render(
        template    => 'users',
        users       => \@user_list,
        cur_user    => $c->session('admin_user') // '',
        base_domain => $c->base_share_domain
    );
}

# POST /admin/users/save
sub save ($c) {
    my $username = $c->param('username') || '';
    my $password = $c->param('password') || '';

    $username =~ s/[^a-zA-Z0-9_\-\.]//g;
    $username =~ s/^\.+//g;
    $password =~ s/^\s+|\s+$//g;

    unless (length($username) >= 3 && length($password) >= 6) {
        $c->flash(err => $c->l('Validation failed: Username must be >= 3 chars and password >= 6 chars.'));
        return $c->redirect_to('/admin/users');
    }

    # Atomic read-modify-write guarded by exclusive file lock
    my $pass_file = $PASSWD_FILE->to_string;
    if (sysopen(my $fh, $pass_file, Fcntl::O_RDWR() | Fcntl::O_CREAT(), 0600)) {
        flock($fh, LOCK_EX);

        my $raw      = do { local $/; <$fh> };
        my $accounts = eval { decode_json($raw) } || {};

        my $new_hash = hmac_sha256_hex($password, $SECRET_KEY);
        $accounts->{$username} = $new_hash;

        seek($fh, 0, 0);
        truncate($fh, 0);
        print $fh encode_json($accounts);
        flock($fh, LOCK_UN);
        close $fh;

        # Keep current session valid if modifying the active account password
        if (($c->session('admin_user') // '') eq $username) {
            $c->session(auth_sig => $c->sign_admin_session($username, $new_hash));
        }
    }

    $c->flash(msg => $c->l('Account [_1] updated successfully.', $username));
    return $c->redirect_to('/admin/users');
}

# POST /admin/users/delete
sub delete ($c) {
    my $target_user = $c->param('username') || '';
    my $cur_user    = $c->session('admin_user') // '';

    # Prevent deleting the current active session account
    if ($target_user eq $cur_user) {
        $c->flash(err => $c->l('Action prohibited: You cannot delete your currently logged-in account.'));
        return $c->redirect_to('/admin/users');
    }

    # Atomic read-modify-delete guarded by exclusive file lock
    my $pass_file = $PASSWD_FILE->to_string;
    if (sysopen(my $fh, $pass_file, Fcntl::O_RDWR() | Fcntl::O_CREAT(), 0600)) {
        flock($fh, LOCK_EX);

        my $raw      = do { local $/; <$fh> };
        my $accounts = eval { decode_json($raw) } || {};

        # Safety restriction: ensure at least one administrative account remains
        if (scalar(keys %$accounts) <= 1) {
            flock($fh, LOCK_UN);
            close $fh;
            $c->flash(err => $c->l('Action prohibited: Cannot remove the last remaining administrative account.'));
            return $c->redirect_to('/admin/users');
        }

        if (exists $accounts->{$target_user}) {
            delete $accounts->{$target_user};
            seek($fh, 0, 0);
            truncate($fh, 0);
            print $fh encode_json($accounts);
            $c->flash(msg => $c->l('Account [_1] removed.', $target_user));
        }

        flock($fh, LOCK_UN);
        close $fh;
    }

    return $c->redirect_to('/admin/users');
}

1;