package Fogshare::Controller::Guest;
#
# Fogshare - Public and Guest Delivery Controller
#
# Copyright (c) 2026 Fogshare Contributors
# Licensed under the MIT License.
#

use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::File   qw(path);
use Mojo::JSON   qw(decode_json encode_json);
use Mojo::Util   qw(url_unescape);
use Digest::SHA  qw(sha256_hex);
use File::Basename;
use Cwd          qw(realpath);
use Fcntl        qw(:flock);
use Encode       qw(decode_utf8);
use Fogshare::Context qw(
    $DIR_ACTIVE $DIR_EXPIRED $DIR_STATS
    $REPO_DIR
);

# Safely sanitize and resolve return paths to prevent open redirect exploits
my $safe_redirect_target = sub ($c, $slug) {
    my $ref    = $c->req->headers->referrer // '';
    my $host   = lc($c->req->url->to_abs->host // '');
    my $is_sub = ($c->stash('slug') && $host =~ /^\Q$slug\E\./i);

    # Mode 1: Subdomain routing (e.g., https://slug.domain.com/)
    if ($is_sub) {
        if ($ref =~ m{^https?://\Q$host\E(/.*)?$}) {
            my $path = $1 || '/';
            $path =~ s{(?:auth|verify)/?$}{};
            $path .= '/' unless $path =~ m{/$};
            return $path;
        }
        return '/';
    }

    # Mode 2: Path prefix routing (e.g., https://domain.com/slug/)
    if ($ref =~ m{^(?:https?://\Q$host\E)?(/\Q$slug\E(?:/.*)?)$}) {
        my $path = $1;
        $path =~ s{(?:auth|verify)/?$}{};
        $path .= '/' unless $path =~ m{/$};
        return $path;
    }

    return "/$slug/";
};

# -----------------------------------------------------------------------------
# Authentication & Verification
# -----------------------------------------------------------------------------

# POST /auth or POST /:slug/auth
sub auth ($c) {
    my $slug = $c->stash('slug') // $c->param('slug') || '';
    my $pass = $c->param('password') || '';
    my $ip   = $c->client_ip;

    # Defense against automated brute-force attacks
    if ($c->check_rate_limit($ip, $slug)) {
        return $c->render(
            template => 'gate',
            slug     => $slug,
            err      => $c->l('Too many failed attempts. Temporarily locked for 15 minutes.')
        );
    }

    my $active_file = $DIR_ACTIVE->child("$slug.json");
    return $c->render(template => 'expired', status => 410) unless -f $active_file;

    my $meta = eval { decode_json($active_file->slurp) };
    return $c->render(
        template   => 'error',
        status     => 500,
        icon_glyph => 'warning',
        title      => $c->l('Internal Server Error'),
        detail     => $c->l('Corrupted share metadata configuration.')
    ) unless $meta;

    my $saved     = $meta->{password} // '';
    my $pass_hash = sha256_hex($pass);

    # Verify plain passphrase or pre-hashed token
    if ($c->secure_compare($pass, $saved) || (length($saved) == 64 && $c->secure_compare($pass_hash, $saved))) {
        $c->clear_rate_failure($ip, $slug);

        my $ts    = time();
        my $token = $c->sign_token($slug, $ts, $saved);

        # Set secure host-only cookie
        my $is_secure_channel = $c->req->is_secure || (($c->req->headers->header('X-Forwarded-Proto') // '') eq 'https');
        my %cookie_opts = (
            path     => '/',
            httponly => 1,
            samesite => 'Lax',
            secure   => ($is_secure_channel || $c->app->sessions->secure) ? 1 : 0,
        );

        $c->cookie("auth_$slug" => "$ts:$token", \%cookie_opts);

        my $target_url = $safe_redirect_target->($c, $slug);
        return $c->redirect_to($target_url);
    }

    $c->record_rate_failure($ip, $slug);
    $c->flash(err => $c->l('Invalid passcode'));

    my $back_url = $safe_redirect_target->($c, $slug);
    return $c->redirect_to($back_url);
}

# POST /verify or POST /:slug/verify
sub verify ($c) {
    my $slug = $c->stash('slug') // $c->param('slug') || '';
    $slug =~ s/[^a-zA-Z0-9_\-]//g;

    my $f = $DIR_ACTIVE->child("$slug.json");
    return $c->render(template => 'expired', status => 410) unless -f $f;

    # 1. Anti-bot gate check
    my $proof = $c->param('human_proof') || '';
    if ($proof ne 'passed') {
        return $c->render(
            template   => 'error',
            status     => 403,
            icon_glyph => 'robot',
            title      => $c->l('Forbidden'),
            detail     => $c->l('Automated access detected.')
        );
    }

    my $dest_url = $safe_redirect_target->($c, $slug);

    # 2. Skip deduction if already unlocked in the current session
    if ($c->session("unlocked_$slug")) {
        return $c->redirect_to($dest_url);
    }

    # 3. Rate-limit verification attempts
    my $ip = $c->client_ip;
    if ($c->check_rate_limit($ip, "verify_$slug")) {
        return $c->render(
            template   => 'error',
            status     => 429,
            icon_glyph => 'speed',
            title      => $c->l('Too Many Requests'),
            detail     => $c->l('Too many verification attempts. Please wait.')
        );
    }

    # 4. Atomic quota deduction guarded by exclusive lock
    my $file_path = $f->to_string;
    open my $fh, '+<', $file_path or return $c->render(template => 'expired', status => 410);
    flock($fh, LOCK_EX);

    my $meta;
    eval {
        my $raw = do { local $/; <$fh> };
        $meta = decode_json($raw);
    };

    unless ($meta) {
        flock($fh, LOCK_UN);
        close $fh;
        return $c->render(template => 'expired', status => 410);
    }

    # Verify authorization before burning quota
    unless ($c->verify_auth($slug, $meta->{password})) {
        $c->record_rate_failure($ip, "verify_$slug");
        flock($fh, LOCK_UN);
        close $fh;
        return $c->render(
            template   => 'error',
            status     => 401,
            icon_glyph => 'lock',
            title      => $c->l('Unauthorized'),
            detail     => $c->l('Please enter the passcode to access this share.')
        );
    }

    my $max_views = int($meta->{max_views} // 0);
    if ($max_views > 0) {
        my $claimed = int($meta->{claimed_views} // 0);

        if ($claimed >= $max_views) {
            flock($fh, LOCK_UN);
            close $fh;
            return $c->render(template => 'expired', status => 410);
        }

        $meta->{claimed_views} = $claimed + 1;

        # Apply a 1-hour grace window once the final quota is reached
        if ($meta->{claimed_views} >= $max_views) {
            my $grace = time() + 3600;
            $meta->{expires_at} = $grace if (!$meta->{expires_at} || $meta->{expires_at} > $grace);
        }

        seek($fh, 0, 0);
        truncate($fh, 0);
        print $fh encode_json($meta);
    }

    flock($fh, LOCK_UN);
    close $fh;

    # 5. Persist unlock state to session
    $c->session("unlocked_$slug" => time());

    return $c->redirect_to($dest_url);
}

# -----------------------------------------------------------------------------
# Share Delivery Dispatcher
# -----------------------------------------------------------------------------

# ANY /*filepath or ANY /:slug/*filepath
sub serve ($c) {
    my $slug = $c->stash('slug');
    $slug = $c->param('slug') unless (defined $slug && length($slug));
    $slug //= '';

    my $filepath = $c->stash('filepath');
    $filepath = $c->param('filepath') unless defined $filepath;
    $filepath //= '';
    $filepath = Mojo::Util::url_unescape($filepath);
    $filepath =~ s{^/+}{};
    $filepath =~ s{/+$}{};

    # Guard internal action endpoints
    if ($filepath =~ m{^(?:verify|auth)$}) {
        return $c->render(
            template => 'error',
            status   => 404,
            title    => $c->l('Not Found'),
            detail   => $c->l('Reserved endpoint')
        );
    }

    # Normalize trailing slash for directory requests
    my $req_path_str = $c->req->url->path->to_string;
    if ($filepath eq '' && $req_path_str ne '/' && !$c->req->url->path->trailing_slash && !$c->param('raw') && !$c->param('download')) {
        my $url = $c->req->url->clone;
        $url->path->trailing_slash(1);
        return $c->redirect_to($url);
    }

    my $active_file = $DIR_ACTIVE->child("$slug.json");
    return $c->render(template => 'expired', status => 410) unless -f $active_file;

    my $meta = eval { decode_json($active_file->slurp) };
    return $c->render(template => 'expired', status => 410) unless $meta;

    # Expire share on TTL timeout
    if ($meta->{expires_at} > 0 && time() > $meta->{expires_at}) {
        $active_file->move_to($DIR_EXPIRED->child("$slug.json"));
        return $c->render(template => 'expired', status => 410);
    }

    # Passcode gate
    unless ($c->verify_auth($slug, $meta->{password})) {
        return $c->render(template => 'gate', slug => $slug, err => '');
    }

    # Burn-after-reading quota gating
    my $max_views = int($meta->{max_views} // 0);
    if ($max_views > 0) {
        my $session_unlocked = $c->session("unlocked_$slug");
        unless ($session_unlocked) {
            my $claimed = int($meta->{claimed_views} // 0);
            if ($claimed >= $max_views) {
                return $c->render(template => 'expired', status => 410);
            }

            my $ua          = $c->req->headers->user_agent            // '';
            my $x_purpose   = $c->req->headers->header('X-Purpose')   // '';
            my $purpose     = $c->req->headers->header('Purpose')     // '';
            my $sec_purpose = $c->req->headers->header('Sec-Purpose') // '';

            # Detect web crawlers and link prefetchers to prevent quota exhaustion
            my $is_bot = (
                $ua =~ m{(?:Twitterbot|facebookexternalhit|LinkedInBot|Slackbot|TelegramBot|Discordbot|WhatsApp|Applebot|Googlebot|bingbot|Baiduspider)}i
                || $x_purpose =~ /preview/i
                || $purpose =~ /prefetch/i
                || $sec_purpose =~ /prefetch/i
            );

            return $c->render(
                template   => 'gatekeeper',
                slug       => $slug,
                views_left => ($max_views - $claimed),
                note       => $meta->{note} // ''
            );
        }
    }

    my $target = $REPO_DIR->child($meta->{target});
    unless (-e $target) {
        return $c->render(
            template   => 'error',
            status     => 404,
            icon_glyph => 'folder_off',
            title      => $c->l('Target Missing'),
            detail     => $c->l('The underlying file or directory has been removed from storage.')
        );
    }

    # Record metrics for primary page hits
    my $is_page_hit = (
        (-f $target && $filepath eq '' && !$c->param('raw') && !$c->param('download'))
        || (-d $target && ($filepath eq '' || $filepath =~ m{^(?:.*/)?index\.html?$}i))
    );

    if ($is_page_hit) {
        if (open my $fh, '>>', $DIR_STATS->child("$slug.hits")->to_string) {
            say $fh time();
            close $fh;
        }
    }

    # Serve shared vendor libraries if requested
    if ($filepath =~ m{^libs/(.+)$}) {
        return $c->serve_shared_lib($1);
    }

    # -------------------------------------------------------------------------
    # Branch A: Single File Delivery
    # -------------------------------------------------------------------------
    if (-f $target) {
        my $target_name = basename($target->to_string);

        if ($c->param('download')) {
            return $c->serve_storage_file($target, $c->get_mime_type($target->to_string), $target_name);
        }

        if ($c->param('raw') || (length($filepath) && $filepath eq $target_name)) {
            $c->res->headers->header('Content-Disposition' => 'inline');
            return $c->serve_storage_file($target, $c->get_mime_type($target->to_string));
        }

        if (length($filepath) && $filepath ne $target_name) {
            return $c->render(
                template   => 'error',
                status     => 404,
                icon_glyph => 'search_off',
                title      => $c->l('Not Found'),
                detail     => $c->l('Target [_1] does not exist.', $filepath)
            );
        }

        if ($target =~ /\.html?$/i) {
            return $c->serve_storage_file($target, 'text/html; charset=utf-8');
        }

        # Apply strict CSP for standalone file showcase views
        $c->res->headers->header('X-Content-Type-Options'  => 'nosniff');
        $c->res->headers->header(
            'Content-Security-Policy' => "default-src 'self' 'unsafe-inline'; "
                . "script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net; "
                . "style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://fonts.googleapis.com; "
                . "font-src 'self' https://fonts.gstatic.com https://cdn.jsdelivr.net data:; "
                . "img-src 'self' data: blob:;"
        );

        my $mime = $c->get_mime_type($target->to_string);
        my ($ext) = $target->to_string =~ /\.([^.]+)$/;
        $ext = lc($ext // '');

        my $content_raw = '';
        if ($ext =~ /^(md|markdown|txt|py|js|mjs|json|sh|sql|css|yml|yaml|xml|c|cpp|rs|go|pl)$/) {
            my $bytes = eval { $target->slurp } // '';
            $content_raw = eval { Encode::decode_utf8($bytes) } // $bytes;
        }

        return $c->render(
            template    => 'showcase',
            slug        => $slug,
            meta        => $meta,
            filename    => $target_name,
            size_str    => $c->format_bytes(-s $target),
            mime        => $mime,
            file_ext    => $ext,
            content_raw => $content_raw
        );
    }

    # -------------------------------------------------------------------------
    # Branch B: Directory Delivery
    # -------------------------------------------------------------------------
    if (-d $target) {
        $filepath =~ s{^/+}{};
        $filepath =~ s{/+$}{};

        if ($filepath =~ m{(?:^|/)\.\.(?:/|$)}) {
            return $c->render(
                template   => 'error',
                status     => 403,
                icon_glyph => 'block',
                title      => $c->l('Forbidden'),
                detail     => $c->l('Directory traversal or unauthorized path access detected.')
            );
        }

        if ($filepath =~ m{(?:^|/)\.}) {
            return $c->render(
                template   => 'error',
                status     => 403,
                icon_glyph => 'lock',
                title      => $c->l('Access Denied'),
                detail     => $c->l('Access to hidden files or system metadata is strictly prohibited.')
            );
        }

        my $req_file    = length $filepath ? $target->child($filepath) : $target;
        my $req_real    = -e $req_file ? realpath($req_file->to_string) : undef;
        my $target_real = realpath($target->to_string);

        if ($req_real) {
            my $is_safe = ($req_real eq $target_real || index($req_real, "$target_real/") == 0);
            unless ($is_safe) {
                return $c->render(
                    template   => 'error',
                    status     => 403,
                    icon_glyph => 'block',
                    title      => $c->l('Forbidden'),
                    detail     => $c->l('Directory traversal or unauthorized path access detected.')
                );
            }

            # Directory listing or auto-index dispatch
            if (-d $req_real) {
                my $idx = path($req_real)->child('index.html');
                if (-f $idx) {
                    return $c->serve_storage_file($idx, 'text/html; charset=utf-8');
                }

                if (length $filepath && !$c->req->url->path->trailing_slash) {
                    my $url = $c->req->url->clone;
                    $url->path->trailing_slash(1);
                    return $c->redirect_to($url);
                }

                my @dir_items;
                if (opendir(my $dh, $req_real)) {
                    while (my $entry = readdir($dh)) {
                        next if $entry =~ /^\./;
                        $entry = decode_utf8($entry);
                        my $e_abs = path($req_real)->child($entry);
                        push @dir_items, {
                            name   => $entry,
                            is_dir => -d $e_abs,
                            size   => -d $e_abs ? '-' : $c->format_bytes(-s $e_abs)
                        };
                    }
                    closedir($dh);
                }

                @dir_items = sort { $b->{is_dir} <=> $a->{is_dir} || lc($a->{name}) cmp lc($b->{name}) } @dir_items;

                return $c->render(
                    template => 'directory',
                    slug     => $slug,
                    meta     => $meta,
                    items    => \@dir_items,
                    cur_sub  => $filepath
                );
            }

            # Static file within shared directory
            if (-f $req_real) {
                my $dl_name = $c->param('download') ? basename($req_real) : undef;
                return $c->serve_storage_file(path($req_real), $c->get_mime_type($req_real), $dl_name);
            }
        }

        # Single Page Application (SPA) fallback resolution (e.g. 200.html / index.html)
        my $is_static_asset = ($filepath =~ /\.(?:html?|js|mjs|css|png|jpe?g|gif|svg|ico|webp|avif|woff2?|ttf|eot|wasm|map|json|xml|txt|pdf|zip|tar|gz|mp4|webm|mp3)$/i);
        if (!$is_static_asset) {
            my $fallback = $target->child('200.html');
            $fallback = $target->child('index.html') unless -f $fallback;
            if (-f $fallback) {
                return $c->serve_storage_file($fallback, 'text/html; charset=utf-8');
            }
        }

        return $c->render(
            template   => 'error',
            status     => 404,
            icon_glyph => 'search_off',
            title      => $c->l('Not Found'),
            detail     => $c->l('Target [_1] does not exist.', $filepath)
        );
    }
}

1;