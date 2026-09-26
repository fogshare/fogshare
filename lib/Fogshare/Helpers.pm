package Fogshare::Helpers;
#
# Fogshare - Global Helper Functions and Request Pipeline
#
# Copyright (c) 2026 Fogshare Contributors
# Licensed under the MIT License.
#

use Mojo::Base 'Mojolicious::Plugin', -signatures;
use Mojo::File  qw(path);
use Mojo::JSON  qw(decode_json encode_json);
use Digest::SHA qw(hmac_sha256_hex);
use File::Basename;
use POSIX             qw(ceil);
use Cwd               qw(realpath);
use Fcntl             qw(:flock);
use Encode            qw(encode_utf8 decode_utf8);
use Mojo::Util        qw(url_escape secure_compare);
use Fogshare::Context qw(
    $SECRET_KEY $REPO_DIR $SHARED_LIBS $DIR_ACTIVE $SHM_DIR
    $PASSWD_FILE $MAX_ZIP_ENTRIES $MAX_UNZIP_BYTES $MAX_COMPRESSION_RATIO
    $RESERVED_SLUGS_RE $ENABLE_X_ACCEL
    $LINK_MODE $ADMIN_DOMAIN $SHARE_DOMAIN
);

# Syllables used for generating readable, 4-syllable / 8-character Cute Slugs
my @SYLLABLES = qw(
    ba be bi bo bu pa pe pi po pu
    ca co cu ka ke ki ko ku
    ma me mi mo mu na ne ni no nu
    ta te ti to tu da de di do du
    la le li lo lu ra ri ro ru
    ya yo yu wa wi wo
    fa fi fo fu sa si so su za zi zo
);

sub register ($self, $app, $conf = {}) {

    # -------------------------------------------------------------------------
    # Global Request Pipeline Hook
    # -------------------------------------------------------------------------
    $app->hook(before_dispatch => sub ($c) {
        # Respect preferred language from cookie
        if (my $lang = $c->cookie('fogshare_lang')) {
            $c->languages($lang);
        }

        # Populate branding and UI assets into stash
        $c->stash(
            site_name   => $Fogshare::Context::SITE_NAME,
            favicon_url => $Fogshare::Context::FAVICON_URL,
            logo_url    => $Fogshare::Context::LOGO_URL,
            footer_html => $Fogshare::Context::FOOTER_HTML,
            custom_css  => $Fogshare::Context::CUSTOM_CSS,
            custom_js   => $Fogshare::Context::CUSTOM_JS,
        );

        my $host = lc($c->req->url->to_abs->host // '');

        # Check if the current host matches the configured admin domain or local hosts
        my $is_admin = (
            (defined $ADMIN_DOMAIN && length($ADMIN_DOMAIN) && $host eq lc($ADMIN_DOMAIN))
            || $host eq 'localhost'
            || $host eq 'admin.localhost'
            || $host eq '127.0.0.1'
            || $host eq '[::1]'
        );
        if ($is_admin) {
            $c->stash( is_admin_host => 1 );
            return;
        }

        # Check for subdomain-based share routing (e.g., slug.localhost or slug.domain.com)
        if ($host =~ /^([a-zA-Z0-9_\-]+)\.localhost$/i
            || ($SHARE_DOMAIN && $host =~ /^([a-zA-Z0-9_\-]+)\.\Q$SHARE_DOMAIN\E$/i))
        {
            my $sub = $1;
            unless ($sub =~ $RESERVED_SLUGS_RE) {
                $c->stash(slug => $sub, is_subdomain => 1);
                return;
            }
        }
    });

    # -------------------------------------------------------------------------
    # Internal Scheme and Port Resolvers
    # -------------------------------------------------------------------------
    my $_resolve_public_scheme = sub ($c) {
        my $fwd_proto = $c->req->headers->header('X-Forwarded-Proto') // '';
        my $cf_vis    = $c->req->headers->header('CF-Visitor')        // '';
        my $is_secure = $c->req->is_secure
            || ($fwd_proto =~ /https/i)
            || ($cf_vis =~ /"scheme":"https"/i)
            || $ENV{APP_ENABLE_HTTPS}
            || $Fogshare::Context::CONFIG->{enable_https};

        return $is_secure ? 'https' : lc($c->req->url->base->scheme || 'http');
    };

    my $_resolve_public_port_str = sub ($c, $scheme) {
        my $fwd_port = $c->req->headers->header('X-Forwarded-Port');
        my $port;

        if ($fwd_port && $fwd_port =~ /(\d+)/) {
            $port = int($1);
        } else {
            # Extract first proxy hop host if chained
            my $host_raw = $c->req->headers->header('X-Forwarded-Host') || $c->req->headers->host || '';
            $host_raw =~ s/,\s*.*$//;
            $port = int($1) if $host_raw =~ /:(\d+)$/;
        }

        $port //= $c->req->url->base->port;
        my $is_default = (
            ($scheme eq 'http'  && (!$port || $port == 80))
            || ($scheme eq 'https' && (!$port || $port == 443))
        );

        return ($port && !$is_default) ? ":$port" : '';
    };

    # Timing-attack safe string comparison
    $app->helper(secure_compare => sub ($c, $a, $b) {
        return 0 unless defined $a && defined $b;
        return Mojo::Util::secure_compare($a, $b);
    });

    # Construct public share URL based on routing mode (subdomain vs path prefix)
    $app->helper(build_share_url => sub ($c, $slug) {
        return '' unless defined $slug && length $slug;

        my $scheme   = $_resolve_public_scheme->($c);
        my $port_str = $_resolve_public_port_str->($c, $scheme);
        my $req_host = lc($c->req->url->to_abs->host // '');
        my $is_local = (
            $req_host =~ /^(?:127\.0\.0\.1|localhost|\[::1\]|\d+\.\d+\.\d+\.\d+)$/
            || $req_host =~ /\.localhost$/
        );

        if ($is_local) {
            if ($LINK_MODE eq 'subdomain') {
                return "$scheme://$slug.localhost$port_str/";
            }
            return "$scheme://$req_host$port_str/$slug/";
        }

        if ($LINK_MODE eq 'subdomain') {
            return "$scheme://$slug.$SHARE_DOMAIN$port_str/";
        }
        return "$scheme://$SHARE_DOMAIN$port_str/$slug/";
    });

    # Base domain helper for share endpoints
    $app->helper(base_share_domain => sub ($c) {
        my $scheme   = $_resolve_public_scheme->($c);
        my $port_str = $_resolve_public_port_str->($c, $scheme);
        return "$SHARE_DOMAIN$port_str";
    });

    # Calculate TTL seconds from numerical value and unit specifier
    $app->helper(calc_ttl => sub ($c, $val, $unit = 's') {
        $val = int($val // 0);
        return 0 if $val <= 0;

        my %multipliers = (
            s => 1,
            m => 60,
            h => 3600,
            d => 86400,
            w => 604800,
            M => 2592000,
            y => 31536000,
        );

        return $val * ($multipliers{$unit} // 1);
    });

    # Verify if a slug collides with internal system endpoints
    $app->helper(is_reserved_slug => sub ($c, $slug) {
        return 1 unless length $slug;
        return $slug =~ $RESERVED_SLUGS_RE;
    });

    # Generate a pronounceable 4-syllable Cute Slug
    $app->helper(generate_slug => sub ($c) {
        for (1 .. 10) {
            my $val24 = int(rand(2**24));
            my $i1    = ($val24 >> 18) & 0x3F;
            my $i2    = ($val24 >> 12) & 0x3F;
            my $i3    = ($val24 >> 6)  & 0x3F;
            my $i4    = $val24 & 0x3F;
            my $slug  = join('', @SYLLABLES[$i1, $i2, $i3, $i4]);

            next if $c->is_reserved_slug($slug);
            return $slug unless -f $DIR_ACTIVE->child("$slug.json");
        }
        return 'demo' . int(rand(9999));
    });

    # Determine accurate MIME type with UTF-8 support for code assets
    $app->helper(get_mime_type => sub ($c, $filename) {
        my ($ext) = $filename =~ /\.([^.]+)$/;
        return 'application/octet-stream' unless $ext;
        $ext = lc($ext);

        state $code_exts = {
            map { $_ => 1 } qw(
                sh bash zsh pl pm py pyw php phtml cgi rb lua
                c cpp h hpp rs go sql yml yaml env
            )
        };
        return 'text/plain; charset=utf-8' if $code_exts->{$ext};

        state $core_types = {
            html => 'text/html; charset=utf-8',
            js   => 'application/javascript; charset=utf-8',
            mjs  => 'application/javascript; charset=utf-8',
            css  => 'text/css; charset=utf-8',
            json => 'application/json; charset=utf-8',
            md   => 'text/markdown; charset=utf-8',
            wasm => 'application/wasm',
            svg  => 'image/svg+xml',
        };
        return $core_types->{$ext} if $core_types->{$ext};

        my $builtin = $c->app->types->type($ext);
        if ($builtin) {
            return "$builtin; charset=utf-8" if $builtin =~ /^text\// && $builtin !~ /charset=/;
            return $builtin;
        }

        return 'application/octet-stream';
    });

    # Cryptographic signature helpers
    $app->helper(sign_token => sub ($c, $slug, $ts, $pwd = '') {
        return hmac_sha256_hex("$slug:$ts:$pwd", $SECRET_KEY);
    });

    $app->helper(sign_admin_session => sub ($c, $user, $saved_pass) {
        return hmac_sha256_hex("$user:$saved_pass", $SECRET_KEY);
    });

    # Validate share password token from cookie
    $app->helper(verify_auth => sub ($c, $slug, $saved_pwd) {
        return 1 unless length($saved_pwd // '');

        my $cookie = $c->cookie("auth_$slug");
        return 0 unless $cookie;

        my ($ts, $sign) = split(/:/, $cookie, 2);
        return 0 unless $ts && $sign;
        return 0 if (time() - $ts) > 86400;

        return 1 if secure_compare($c->sign_token($slug, $ts, $saved_pwd), $sign);
        return 0;
    });

    # Check active shares associated with a storage file/directory path
    $app->helper(is_path_shared => sub ($c, $target_rel) {
        my @matched;
        $DIR_ACTIVE->list->each(sub ($f, $num) {
            return unless $f =~ /\.json$/;
            my $meta = eval { decode_json($f->slurp) };
            if ($meta && $meta->{target} eq $target_rel) {
                push @matched, $meta->{slug};
            }
        });
        return @matched;
    });

    # Format byte count into human-readable representation
    $app->helper(format_bytes => sub ($c, $bytes) {
        return '0 B' unless $bytes && $bytes > 0;
        my @units = ('B', 'KB', 'MB', 'GB', 'TB');
        my $i     = 0;
        my $size  = $bytes;

        while ($size >= 1024 && $i < $#units) {
            $size /= 1024;
            $i++;
        }
        return sprintf($i == 0 ? "%.0f %s" : "%.2f %s", $size, $units[$i]);
    });

    # Format expiration TTL countdown
    $app->helper(format_ttl_remaining => sub ($c, $expires_at) {
        return $c->l('Never') if !$expires_at || $expires_at == 0;

        my $diff = $expires_at - time();
        return $c->l('Expired') if $diff <= 0;

        if ($diff >= 86400 * 2) {
            return sprintf("%.1f%s", $diff / 86400, $c->l('d left'));
        } elsif ($diff >= 3600) {
            return sprintf("%.1f%s", $diff / 3600, $c->l('h left'));
        } elsif ($diff >= 60) {
            return sprintf("%d%s", int($diff / 60), $c->l('m left'));
        } else {
            return sprintf("%d%s", $diff, $c->l('s left'));
        }
    });

    # -------------------------------------------------------------------------
    # Rate Limiting Subsystem (Atomic file locking via SHM)
    # -------------------------------------------------------------------------

    # Check whether the IP has exceeded authentication failure thresholds
    $app->helper(check_rate_limit => sub ($c, $ip, $slug) {
        my $key  = ($ip . '.' . $slug) =~ s/[^a-zA-Z0-9_\-\.]/_/gr;
        my $file = $SHM_DIR->child($key);
        return 0 unless -f $file;

        open my $fh, '+<', $file->to_string or return 0;
        flock($fh, LOCK_EX);

        my $content = <$fh> // '';
        my ($count, $lock_until, $first_fail) = split(/:/, $content);
        my $now = time();

        if ($lock_until && $now < $lock_until) {
            flock($fh, LOCK_UN);
            close $fh;
            return 1;
        }

        # Clear expired failure tracking windows
        if ($first_fail && ($now - $first_fail) > 60 && $now >= ($lock_until || 0)) {
            truncate($fh, 0);
            seek($fh, 0, 0);
            flock($fh, LOCK_UN);
            close $fh;
            $file->remove if -f $file;
            return 0;
        }

        flock($fh, LOCK_UN);
        close $fh;
        return 0;
    });

    # Record failed authentication attempt and apply exponential temporary ban
    $app->helper(record_rate_failure => sub ($c, $ip, $slug) {
        my $key  = ($ip . '.' . $slug) =~ s/[^a-zA-Z0-9_\-\.]/_/gr;
        my $file = $SHM_DIR->child($key);
        my $now  = time();

        sysopen(my $fh, $file->to_string, Fcntl::O_RDWR() | Fcntl::O_CREAT(), 0600) or return;
        flock($fh, LOCK_EX);

        my $content = <$fh> // '';
        my ($count, $lock_until, $first_fail) = split(/:/, $content);
        $count      ||= 0;
        $lock_until ||= 0;
        $first_fail ||= $now;

        # Reset window after inactivity
        if (($now - $first_fail) > 180) {
            $count      = 0;
            $first_fail = $now;
        }

        $count++;
        $lock_until = $now + 900 if $count >= 5;

        seek($fh, 0, 0);
        truncate($fh, 0);
        print $fh join(':', $count, $lock_until, $first_fail);

        flock($fh, LOCK_UN);
        close $fh;
    });

    # Clear rate limit failure status on successful authentication
    $app->helper(clear_rate_failure => sub ($c, $ip, $slug) {
        my $key  = ($ip . '.' . $slug) =~ s/[^a-zA-Z0-9_\-\.]/_/gr;
        my $file = $SHM_DIR->child($key);
        $file->remove if -f $file;
    });

    # Map file extensions to Prism.js syntax highlighter tokens
    $app->helper(prism_lang => sub ($c, $ext) {
        state $alias = {
            pl  => 'perl',
            py  => 'python',
            js  => 'javascript',
            sh  => 'bash',
            yml => 'yaml',
            md  => 'markdown'
        };
        return $alias->{$ext} // $ext;
    });

    # Administrative user account persistence helpers
    $app->helper(load_accounts => sub ($c) {
        return -f $PASSWD_FILE ? eval { decode_json($PASSWD_FILE->slurp) } || {} : {};
    });

    $app->helper(save_accounts => sub ($c, $accounts) {
        $PASSWD_FILE->spurt(encode_json($accounts));
    });

    # -------------------------------------------------------------------------
    # Static & Storage File Delivery
    # -------------------------------------------------------------------------

    # Serve file from storage repository with X-Accel support or native streaming
    $app->helper(serve_storage_file => sub ($c, $abs_path, $content_type, $download_name = undef) {
        $c->res->headers->header('X-Content-Type-Options' => 'nosniff');

        # Isolate SVG execution with strict CSP
        if ($content_type =~ m{image/svg\+xml}i) {
            $c->res->headers->header('Content-Security-Policy' => "default-src 'none'; style-src 'unsafe-inline';");
        }

        if (defined $download_name) {
            my $encoded = url_escape(encode_utf8($download_name));
            $c->res->headers->header('Content-Disposition' => "attachment; filename=\"$encoded\"; filename*=UTF-8''$encoded");
        }

        my $accel_supported = $c->req->headers->header('X-Accel-Support');
        my $has_nginx       = $accel_supported || ($ENABLE_X_ACCEL && $c->req->headers->header('X-Forwarded-For'));

        # Offload file transfer to Nginx via X-Accel-Redirect when available
        if ($has_nginx) {
            my $repo_abs = $REPO_DIR->to_string;
            my $libs_abs = $SHARED_LIBS->to_string;
            my $file_str = $abs_path->to_string;

            if (index($file_str, "$repo_abs/") == 0) {
                my $rel_uri     = substr($file_str, length($repo_abs));
                my $raw_bytes   = Encode::is_utf8($rel_uri) ? encode_utf8($rel_uri) : $rel_uri;
                my $escaped_uri = url_escape($raw_bytes, '^A-Za-z0-9\-\._~/');

                $c->res->headers->header('X-Accel-Redirect' => "/_internal_files$escaped_uri");
                $c->res->headers->content_type($content_type) if $content_type;
                return $c->rendered(200);
            } elsif (index($file_str, "$libs_abs/") == 0) {
                my $rel_uri     = substr($file_str, length($libs_abs));
                my $raw_bytes   = Encode::is_utf8($rel_uri) ? encode_utf8($rel_uri) : $rel_uri;
                my $escaped_uri = url_escape($raw_bytes, '^A-Za-z0-9\-\._~/');

                $c->res->headers->header('X-Accel-Redirect' => "/_internal_libs$escaped_uri");
                $c->res->headers->content_type($content_type) if $content_type;
                return $c->rendered(200);
            }
        }

        $c->res->headers->content_type($content_type) if $content_type;
        return $c->reply->file($abs_path->to_string);
    });

    # Deliver shared vendor assets from libs/ directory
    $app->helper(serve_shared_lib => sub ($c, $lib_rel) {
        $lib_rel //= '';
        $lib_rel =~ s{^/+}{};
        $lib_rel =~ s{/+$}{};

        my $shared_file = $SHARED_LIBS->child($lib_rel);
        my $shared_real = realpath($shared_file->to_string);
        my $libs_real   = realpath($SHARED_LIBS->to_string);

        # Verify realpath containment to prevent directory traversal
        if ($shared_real && $libs_real && index($shared_real, "$libs_real/") == 0 && -f $shared_real) {
            $c->res->headers->cache_control('public, max-age=2592000, no-transform');
            return $c->serve_storage_file(path($shared_real), $c->get_mime_type($shared_real));
        }

        return $c->render(
            template   => 'error',
            status     => 404,
            icon_glyph => 'inventory_2',
            title      => $c->l('Library Not Found'),
            detail     => $c->l('Virtual shared library [_1] does not exist in libs/.', $lib_rel)
        );
    });

    # In-memory array pagination helper
    $app->helper(paginate => sub ($c, $items, $page = 1, $per_page = 25) {
        $page     = int($page // 1);
        $per_page = int($per_page // 25);
        $page     = 1  if $page < 1;
        $per_page = 25 if $per_page < 5 || $per_page > 100;

        my $total       = scalar @$items;
        my $total_pages = $total > 0 ? ceil($total / $per_page) : 1;
        $page = $total_pages if $page > $total_pages;

        my $start = ($page - 1) * $per_page;
        my $end   = $start + $per_page - 1;
        $end = $total - 1 if $end >= $total;

        my @paged_items = ($total > 0 && $start < $total) ? @{$items}[$start .. $end] : ();

        return {
            items       => \@paged_items,
            total       => $total,
            page        => $page,
            per_page    => $per_page,
            total_pages => $total_pages,
            has_prev    => $page > 1 ? 1 : 0,
            has_next    => $page < $total_pages ? 1 : 0,
        };
    });

    # Verify zip safety before extraction (defense against zip bombs)
    $app->helper(validate_zip_safety => sub ($c, $zip_obj) {
        my $total_uncompressed = 0;
        my $total_compressed   = 0;
        my $entry_count        = 0;

        for my $member ($zip_obj->members) {
            $entry_count++;
            if ($entry_count > $MAX_ZIP_ENTRIES) {
                return (0, "Zip safety check failed: Entry count exceeds limit ($MAX_ZIP_ENTRIES files/directories max).");
            }

            unless ($member->isDirectory) {
                my $u_size = $member->uncompressedSize();
                my $c_size = $member->compressedSize() || 1;
                $total_uncompressed += $u_size;
                $total_compressed   += $c_size;

                if ($total_uncompressed > $MAX_UNZIP_BYTES) {
                    my $limit_mb = int($MAX_UNZIP_BYTES / (1024 * 1024));
                    return (0, "Zip safety check failed: Total uncompressed size exceeds limit ($limit_mb MB max).");
                }
            }
        }

        if ($total_compressed > 0) {
            my $ratio = $total_uncompressed / $total_compressed;
            if ($ratio > $MAX_COMPRESSION_RATIO) {
                return (0, sprintf("Zip safety check failed: Suspicious compression ratio (%.1f:1 exceeds max %d:1).", $ratio, $MAX_COMPRESSION_RATIO));
            }
        }

        return (1, "OK");
    });

    # -------------------------------------------------------------------------
    # Network and Security Boundary Helpers
    # -------------------------------------------------------------------------
    my $is_private_or_loopback = sub ($ip) {
        return 0 unless defined $ip && length $ip;
        return 1 if $ip eq '127.0.0.1' || $ip eq '::1';
        return 1 if $ip =~ /^127\./;
        return 1 if $ip =~ /^10\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;
        return 1 if $ip =~ /^172\.(?:1[6-9]|2\d|3[01])\.\d{1,3}\.\d{1,3}$/;
        return 1 if $ip =~ /^192\.168\.\d{1,3}\.\d{1,3}$/;
        return 0;
    };

    # Resolve real client IP address handling reverse-proxy hops
    $app->helper(client_ip => sub ($c) {
        my $remote = $c->tx->remote_address // '';
        $remote =~ s/:\d+$//;
        return $remote unless $is_private_or_loopback->($remote);

        my $xff_raw = $c->req->headers->header('X-Forwarded-For') // '';
        if (length $xff_raw) {
            my @hops = map { s/^\s+|\s+$//gr =~ s/:\d+$//r } split /,/, $xff_raw;
            while (@hops) {
                my $candidate = pop @hops;
                next unless defined $candidate && length $candidate;
                return $candidate unless $is_private_or_loopback->($candidate);
            }
        }

        if (my $real = $c->req->headers->header('X-Real-IP')) {
            $real =~ s/:\d+$//;
            $real =~ s/^\s+|\s+$//g;
            return $real if length $real;
        }

        return $remote;
    });

    # Strict containment check preventing directory traversal outside REPO_DIR
    $app->helper(check_repo_boundary => sub ($c, $path_obj) {
        return 0 unless defined $path_obj;

        my $repo_real = realpath($REPO_DIR->to_string);
        return 0 unless $repo_real;

        if (-e $path_obj) {
            my $target_real = realpath($path_obj->to_string);
            return 0 unless $target_real;
            return ($target_real eq $repo_real || index($target_real, "$repo_real/") == 0) ? 1 : 0;
        }

        my $parent_real = realpath($path_obj->dirname->to_string);
        return 0 unless $parent_real;
        return ($parent_real eq $repo_real || index($parent_real, "$repo_real/") == 0) ? 1 : 0;
    });
}

1;