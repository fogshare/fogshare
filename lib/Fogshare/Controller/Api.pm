package Fogshare::Controller::Api;
#
# Fogshare - RESTful API Controller (CLI & Automation Integration)
#
# Copyright (c) 2026 Fogshare Contributors
# Licensed under the MIT License.
#

use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::File        qw(path);
use Mojo::JSON        qw(decode_json encode_json);
use Archive::Zip      qw(:ERROR_CODES :CONSTANTS);
use File::Path        qw(remove_tree);
use Cwd               qw(realpath);
use Encode            qw(decode_utf8);
use Fogshare::Context qw(
    $API_TOKEN $REPO_DIR $DIR_ACTIVE $DIR_TRASH
);

# -----------------------------------------------------------------------------
# Authentication Guard
# -----------------------------------------------------------------------------

# Authenticate incoming API request via Bearer header, X-API-Token, or param
sub _check_auth ($c) {
    unless (length($API_TOKEN)) {
        $c->render(
            json   => { error => 'API service is disabled: APP_API_TOKEN is not configured' },
            status => 503
        );
        return 0;
    }

    my $auth_header = $c->req->headers->header('Authorization') // '';
    my ($bearer)    = $auth_header =~ /^Bearer\s+(\S+)$/i;
    my $token       = $c->req->headers->header('X-API-Token') || $bearer || $c->param('token') || '';

    if (length($token) && $c->secure_compare($token, $API_TOKEN)) {
        return 1;
    }

    $c->render(
        json   => { error => 'Unauthorized: Invalid or missing API token' },
        status => 401
    );
    return 0;
}

# -----------------------------------------------------------------------------
# API Endpoints
# -----------------------------------------------------------------------------

# POST /api/deploy
sub deploy ($c) {
    return unless $c->_check_auth;

    my $upload = $c->req->upload('file');
    unless ($upload && $upload->size > 0) {
        return $c->render(
            json   => { error => 'Bad Request: No file uploaded (form field: "file")' },
            status => 400
        );
    }

    my $slug = $c->param('slug') || '';
    $slug =~ s/[^a-zA-Z0-9_\-]//g;

    if (length($slug) && $c->is_reserved_slug($slug)) {
        return $c->render(
            json   => { error => "Bad Request: Slug [$slug] is a reserved system keyword" },
            status => 400
        );
    }

    $slug = $c->generate_slug() unless length $slug;

    my $is_zip       = ($upload->filename =~ /\.zip$/i) ? 1 : 0;
    my $unzip_param  = $c->param('unzip');
    my $should_unzip = defined($unzip_param) ? ($unzip_param ? 1 : 0) : $is_zip;
    my $target_rel   = $slug;

    # Branch A: Unpack zip deployment payload
    if ($is_zip && $should_unzip) {
        my $unzip_target = $REPO_DIR->child($slug)->make_path;

        # Clear existing deployment directory payload when updating in-place
        if (-d $unzip_target) {
            remove_tree($_->to_string) for $unzip_target->list->each;
        }

        my $tmp_zip = $unzip_target->child('.upload.tmp.zip');
        $upload->move_to($tmp_zip);

        my $zip = Archive::Zip->new();
        if ($zip->read($tmp_zip->to_string) == AZ_OK) {
            my ($is_safe, $err_msg) = $c->validate_zip_safety($zip);
            unless ($is_safe) {
                $tmp_zip->remove;
                return $c->render(json => { error => "Unprocessable Entity: $err_msg" }, status => 422);
            }

            my $target_root_real = realpath($unzip_target->to_string);
            unless ($target_root_real) {
                $tmp_zip->remove if -f $tmp_zip;
                return $c->render(json => { error => 'Internal Error: Failed to resolve unpack boundary' }, status => 500);
            }

            for my $member ($zip->members) {
                next if $member->isSymbolicLink;

                my $m_name = $member->fileName;
                $m_name =~ s{\\}{/}g;
                $m_name =~ s{^[a-zA-Z]:}{} if $^O eq 'MSWin32' || $m_name =~ /^[a-zA-Z]:/;
                $m_name =~ s{^(?:[./\\]+)+}{}g;

                next unless length $m_name;
                next if $m_name =~ m{(?:^|/)(?:\.|__MACOSX|\.DS_Store|\.git)};
                next if $m_name =~ m{(^|/)\.\.(/|$)};

                my $dest_file = $unzip_target->child($m_name);
                my $dest_str  = $dest_file->to_string;
                next unless index($dest_str, "$target_root_real/") == 0;

                if ($member->isDirectory) {
                    $dest_file->make_path;
                } else {
                    $dest_file->dirname->make_path;
                    my $parent_real = realpath($dest_file->dirname->to_string);
                    next unless $parent_real && (index($parent_real, "$target_root_real/") == 0 || $parent_real eq $target_root_real);

                    # Refuse to overwrite existing symbolic links
                    next if -l $dest_str;
                    $zip->extractMember($member, $dest_str);
                }
            }
            $tmp_zip->remove;
        } else {
            $tmp_zip->remove;
            return $c->render(json => { error => 'Corrupted ZIP archive' }, status => 422);
        }
    } else {
        # Branch B: Single standalone file deployment
        my $orig_name = decode_utf8($upload->filename);
        my ($ext)     = $orig_name =~ /\.([a-zA-Z0-9]+)$/;
        $target_rel   = $ext ? "$slug.$ext" : $slug;

        my $target_abs = $REPO_DIR->child($target_rel);
        unless ($c->check_repo_boundary($target_abs)) {
            return $c->render(json => { error => 'Forbidden: Invalid target path' }, status => 403);
        }

        $upload->move_to($target_abs);
    }

    # Inherit and preserve previous share settings if updating an active slug
    my $old_meta_file = $DIR_ACTIVE->child("$slug.json");
    my $old_meta      = -f $old_meta_file ? eval { decode_json($old_meta_file->slurp) } : undef;

    my $ttl_val    = int($c->param('ttl_val') // ($old_meta ? $old_meta->{ttl_val} : 0));
    my $ttl_unit   = $c->param('ttl_unit') // ($old_meta ? $old_meta->{ttl_unit} : 'd');
    my $ttl        = $c->calc_ttl($ttl_val, $ttl_unit);
    my $expires_at = $ttl > 0 ? (time() + $ttl) : ($old_meta ? $old_meta->{expires_at} : 0);

    my $max_views = defined($c->param('max_views'))
        ? int($c->param('max_views') // 0)
        : ($old_meta ? ($old_meta->{max_views} // 0) : 0);

    my $password = defined($c->param('password'))
        ? ($c->param('password') =~ s/^\s+|\s+$//gr)
        : ($old_meta ? $old_meta->{password} : '');

    my $meta = {
        slug          => $slug,
        target        => $target_rel,
        password      => $password,
        note          => $c->param('note') // ($old_meta ? $old_meta->{note} : 'CLI / API Deployment'),
        ttl_val       => $ttl_val,
        ttl_unit      => $ttl_unit,
        max_views     => $max_views,
        claimed_views => $old_meta ? ($old_meta->{claimed_views} // 0) : 0,
        expires_at    => $expires_at,
        created_at    => $old_meta ? $old_meta->{created_at} : time(),
        updated_at    => time()
    };

    $DIR_ACTIVE->child("$slug.json")->spurt(encode_json($meta));

    my $share_url = $c->build_share_url($slug);
    return $c->render(
        json => {
            status       => 'ok',
            slug         => $slug,
            target       => $target_rel,
            url          => $share_url,
            fallback_url => $share_url,
            has_password => length($password) ? 1 : 0,
            max_views    => $meta->{max_views},
            expires_at   => $meta->{expires_at}
        },
        status => 201
    );
}

# GET /api/shares
sub list ($c) {
    return unless $c->_check_auth;

    my @list;
    $DIR_ACTIVE->list->each(sub ($f, $num) {
        return unless $f =~ /\.json$/;
        my $meta = eval { decode_json($f->slurp) };
        if ($meta) {
            push @list, {
                slug          => $meta->{slug},
                url           => $c->build_share_url($meta->{slug}),
                target        => $meta->{target},
                has_password  => length($meta->{password} // '') ? 1 : 0,
                note          => $meta->{note} // '',
                expires_at    => $meta->{expires_at} // 0,
                created_at    => $meta->{created_at} // 0,
                max_views     => $meta->{max_views} // 0,
                claimed_views => $meta->{claimed_views} // 0,
            };
        }
    });

    @list = sort { $b->{created_at} <=> $a->{created_at} } @list;
    return $c->render(json => { status => 'ok', shares => \@list });
}

# POST /api/teardown
sub teardown ($c) {
    return unless $c->_check_auth;

    my $slug = $c->param('slug') || '';
    $slug =~ s/[^a-zA-Z0-9_\-]//g;

    unless (length $slug) {
        return $c->render(json => { error => 'Bad Request: slug is required' }, status => 400);
    }

    my $f = $DIR_ACTIVE->child("$slug.json");
    if (-f $f) {
        $f->move_to($DIR_TRASH->child("$slug.json"));
        return $c->render(json => { status => 'ok', message => "Share [$slug] moved to trash." });
    }

    return $c->render(json => { error => 'NotFound: Active share not found' }, status => 404);
}

1;