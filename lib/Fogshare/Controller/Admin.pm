package Fogshare::Controller::Admin;
#
# Fogshare - Administrative Controller
#
# Copyright (c) 2026 Fogshare Contributors
# Licensed under the MIT License.
#

use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::File   qw(path);
use Mojo::JSON   qw(decode_json encode_json);
use Archive::Zip qw(:ERROR_CODES :CONSTANTS);
use Digest::SHA  qw(hmac_sha256_hex);
use File::Basename;
use File::Path            qw(remove_tree);
use File::Copy::Recursive qw(dircopy fcopy);
use POSIX                 qw(strftime);
use Cwd                   qw(realpath);
use Encode                qw(decode_utf8);
use Fogshare::Context     qw(
    $PASSWD_FILE $SECRET_KEY $REPO_DIR $DIR_ACTIVE $DIR_EXPIRED $DIR_TRASH
);

# Internal helper to normalize and clean traversal segments safely
my $sanitize_rel_path = sub ($p) {
    $p = '' unless defined $p;
    $p =~ s{\\}{/}g;
    $p =~ s{^/+}{};
    $p =~ s{/+$}{};
    1 while $p =~ s{(^|/)\.\.(/|$)}{/}g;
    $p =~ s{^/+}{};
    $p =~ s{/+$}{};
    $p =~ s{//+}{/}g;
    return $p;
};

# -----------------------------------------------------------------------------
# Authentication Endpoints
# -----------------------------------------------------------------------------

# GET /admin/login
sub login_page ($c) {
    $c->render(template => 'login', msg => $c->flash('msg'));
}

# POST /admin/login
sub login_action ($c) {
    my $ip   = $c->client_ip;
    my $user = $c->param('username') || '';
    my $pass = $c->param('password') || '';
    $user =~ s/^\s+|\s+$//g;

    my $user_rate_key = 'admin_user_' . ($user =~ s/[^a-zA-Z0-9_\-\.]/_/gr);

    # Enforce dual-dimension rate limit: by remote IP and target username
    if ($c->check_rate_limit($ip, 'admin_login')
        || (length($user) && $c->check_rate_limit($user_rate_key, 'login')))
    {
        $c->flash(msg => $c->l('Too many failed attempts. Temporarily locked for 15 minutes.'));
        return $c->redirect_to('/');
    }

    my $accounts = -f $PASSWD_FILE ? eval { decode_json($PASSWD_FILE->slurp) } || {} : {};
    my $saved    = $accounts->{$user};

    if (defined $saved && length($saved)) {
        my $salted_hash = hmac_sha256_hex($pass, $SECRET_KEY);
        if ($c->secure_compare($salted_hash, $saved)) {
            $c->clear_rate_failure($ip,            'admin_login');
            $c->clear_rate_failure($user_rate_key, 'login');
            $c->session(
                is_admin   => 1,
                admin_user => $user,
                auth_time  => time(),
                auth_sig   => $c->sign_admin_session($user, $saved)
            );
            return $c->redirect_to('/');
        }
    }

    # Record failure on bad credentials
    $c->record_rate_failure($ip,            'admin_login');
    $c->record_rate_failure($user_rate_key, 'login') if length $user;
    $c->flash(msg => $c->l('Invalid username or password'));
    return $c->redirect_to('/');
}

# GET /admin/logout
sub logout ($c) {
    delete $c->session->{is_admin};
    $c->flash(msg => $c->l('Logged out successfully.'));
    return $c->redirect_to('/');
}

# -----------------------------------------------------------------------------
# Gateway Middleware
# -----------------------------------------------------------------------------

# Gateway guard for administrative paths (under /admin)
sub check_admin ($c) {
    my $auth_time  = $c->session('auth_time') // 0;
    my $is_expired = (!$auth_time || (time() - $auth_time) > 86400 * 7);
    my $user       = $c->session('admin_user') // '';
    my $auth_sig   = $c->session('auth_sig')   // '';
    my $accounts   = $c->load_accounts;
    my $saved_pass = $accounts->{$user};

    # Verify session authenticity and HMAC integrity
    my $is_valid = (
        $c->session('is_admin')
        && !$is_expired
        && defined $saved_pass
        && length($saved_pass)
        && $c->secure_compare($auth_sig, $c->sign_admin_session($user, $saved_pass))
    );

    unless ($is_valid) {
        delete $c->session->{is_admin};
        delete $c->session->{auth_time};
        delete $c->session->{auth_sig};
        $c->redirect_to('/');
        return undef;
    }

    # Verify CSRF token for state-mutating requests
    if ($c->req->method eq 'POST') {
        my $validation = $c->validation;
        if ($validation->csrf_protect->has_error('csrf_token')) {
            $c->flash(err => $c->l('Security Alert: CSRF token validation failed. Action rejected.'));
            my $ref = $c->req->headers->referrer || '/';
            if ($ref =~ m{^(?:https?://[^/]+)?(/(?:admin(?:[/?#].*)?|\?(?:.*)|$))}i) {
                $ref = $1;
            } else {
                $ref = '/';
            }
            $c->redirect_to($ref);
            return undef;
        }
    }

    return 1;
}

# -----------------------------------------------------------------------------
# Admin Dashboard & File Manager
# -----------------------------------------------------------------------------

# GET /admin
sub dashboard ($c) {
    my $tab         = $c->param('tab') || 'files';
    my $rel_p       = $sanitize_rel_path->($c->param('p'));
    my $current_abs = $rel_p ? $REPO_DIR->child($rel_p) : $REPO_DIR;

    # Enforce boundary checks on the navigated directory
    unless (-d $current_abs && $c->check_repo_boundary($current_abs)) {
        $current_abs = $REPO_DIR;
        $rel_p       = '';
    }

    my (%active_count_map, @actives, @expireds, @trashes);

    # Collect and categorize shares
    $DIR_ACTIVE->list->each(sub ($f, $num) {
        return unless $f =~ /\.json$/;
        my $data = eval { decode_json($f->slurp) };
        if ($data) {
            if ($data->{expires_at} > 0 && time() > $data->{expires_at}) {
                $f->move_to($DIR_EXPIRED->child(basename($f)));
            } else {
                push @actives, $data;
                $active_count_map{$data->{target}}++;
            }
        }
    });

    $DIR_EXPIRED->list->each(sub ($f, $num) {
        return unless $f =~ /\.json$/;
        my $data = eval { decode_json($f->slurp) };
        push @expireds, $data if $data;
    });

    $DIR_TRASH->list->each(sub ($f, $num) {
        return unless $f =~ /\.json$/;
        my $data = eval { decode_json($f->slurp) };
        push @trashes, $data if $data;
    });

    # Scan physical storage items in the current directory
    my @current_items;
    if (opendir(my $dh, $current_abs->to_string)) {
        while (my $entry = readdir($dh)) {
            next if $entry =~ /^\./;
            $entry = decode_utf8($entry);

            my $entry_abs = $current_abs->child($entry);
            my $is_d      = -d $entry_abs;
            my $item_rel  = $rel_p ? "$rel_p/$entry" : $entry;
            my @st        = stat($entry_abs->to_string);
            my $mtime     = @st ? strftime('%Y-%m-%d %H:%M', localtime($st[9])) : '-';

            push @current_items, {
                name        => $entry,
                rel         => $item_rel,
                is_dir      => $is_d,
                size        => $is_d ? '-' : $c->format_bytes(-s $entry_abs),
                mtime       => $mtime,
                share_count => $active_count_map{$item_rel} || 0,
            };
        }
        closedir($dh);
    }

    my $page = int($c->param('page') // 1);

    # Sort listings
    @current_items = sort { $b->{is_dir} <=> $a->{is_dir} || lc($a->{name}) cmp lc($b->{name}) } @current_items;
    @actives       = sort { $b->{created_at} <=> $a->{created_at} } @actives;
    @expireds      = sort { ($b->{expires_at} || 0) <=> ($a->{expires_at} || 0) } @expireds;
    @trashes       = sort { ($b->{updated_at} || $b->{created_at} || 0) <=> ($a->{updated_at} || $a->{created_at} || 0) } @trashes;

    my $p_files   = $c->paginate(\@current_items, $page);
    my $p_actives = $c->paginate(\@actives,       $page);
    my $p_expired = $c->paginate(\@expireds,      $page);
    my $p_trash   = $c->paginate(\@trashes,       $page);

    # Build navigational breadcrumbs
    my @breadcrumbs;
    my @parts = split('/', $rel_p);
    my $acc   = '';

    for my $part (@parts) {
        next unless length $part;
        $acc = $acc ? "$acc/$part" : $part;
        push @breadcrumbs, { name => $part, path => $acc };
    }

    $c->render(
        template    => 'admin',
        tab         => $tab,
        cur_path    => $rel_p,
        breadcrumbs => \@breadcrumbs,
        items       => $p_files->{items},
        pagination  => (
              $tab eq 'actives' ? $p_actives
            : $tab eq 'expired' ? $p_expired
            : $tab eq 'trash'   ? $p_trash
            :                     $p_files
        ),
        actives       => $p_actives->{items},
        expireds      => $p_expired->{items},
        trashes       => $p_trash->{items},
        count_files   => scalar(@current_items),
        count_actives => scalar(@actives),
        count_expired => scalar(@expireds),
        count_trash   => scalar(@trashes),
        created       => $c->flash('created'),
        base_domain   => $c->base_share_domain
    );
}

# POST /admin/mkdir
sub make_dir ($c) {
    my $base_p      = $sanitize_rel_path->($c->param('base_path'));
    my $folder_name = $c->param('folder_name') || '';
    $folder_name =~ s{[^a-zA-Z0-9_\-]}{}g;

    unless (length $folder_name) {
        $c->flash(err => $c->l('Invalid folder name.'));
        return $c->redirect_to('/admin?tab=files');
    }

    my $target_dir = length($base_p)
        ? $REPO_DIR->child($base_p)->child($folder_name)
        : $REPO_DIR->child($folder_name);

    unless ($c->check_repo_boundary($target_dir)) {
        $c->flash(err => $c->l('Security Alert: Directory traversal detected.'));
        return $c->redirect_to('/admin?tab=files');
    }

    $target_dir->make_path;
    $c->redirect_to('/admin?tab=files' . ($base_p ? "&p=$base_p" : ''));
}

# POST /admin/upload
sub upload ($c) {
    my $sub_dir    = $sanitize_rel_path->($c->param('target_dir'));
    my $auto_unzip = $c->param('auto_unzip') ? 1 : 0;
    my @files      = @{ $c->req->uploads('files') };
    my @rel_paths  = @{ $c->every_param('rel_paths') };

    if (!@files && (my $single = $c->req->upload('file'))) {
        @files     = ($single);
        @rel_paths = ($single->filename);
    }

    unless (@files) {
        return $c->redirect_to('/admin?tab=files' . (length($sub_dir) ? "&p=$sub_dir" : ''));
    }

    my $dest_base = length($sub_dir) ? $REPO_DIR->child($sub_dir) : $REPO_DIR;
    unless ($c->check_repo_boundary($dest_base)) {
        $c->flash(err => $c->l('Security Alert: Directory traversal detected.'));
        return $c->redirect_to('/admin?tab=files');
    }

    $dest_base->make_path;

    for my $i (0 .. $#files) {
        my $file     = $files[$i];
        my $rel_path = $sanitize_rel_path->($rel_paths[$i] || $file->filename);
        next unless length $rel_path;

        # Handle automatic safe zip extraction
        if ($auto_unzip && $file->filename =~ /\.zip$/i && scalar(@files) == 1) {
            my ($name_no_ext) = $file->filename =~ /(.*)\.zip$/i;
            $name_no_ext =~ s{[^a-zA-Z0-9_\-]}{_}g;

            my $unzip_target = $dest_base->child($name_no_ext)->make_path;
            my $tmp_zip      = $unzip_target->child('upload.tmp.zip');
            $file->move_to($tmp_zip);

            my $zip = Archive::Zip->new();
            if ($zip->read("$tmp_zip") == AZ_OK) {
                my ($is_safe, $err_msg) = $c->validate_zip_safety($zip);
                unless ($is_safe) {
                    $tmp_zip->remove;
                    $c->flash(err => $c->l('Upload rejected: [_1]', $err_msg));
                    return $c->redirect_to("/admin?tab=files&p=$sub_dir");
                }

                my $target_root_real = realpath($unzip_target->to_string);
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

                        # Prevent overwriting existing symbolic links
                        next if -l $dest_str;
                        $zip->extractMember($member, $dest_str);
                    }
                }
            }
            $tmp_zip->remove;
        } else {
            my $target_abs = $dest_base->child($rel_path);
            unless ($c->check_repo_boundary($target_abs)) {
                $c->flash(err => $c->l('Security Alert: Directory traversal detected.'));
                return $c->redirect_to("/admin?tab=files&p=$sub_dir");
            }
            my $parent_dir = path(dirname($target_abs->to_string));
            $parent_dir->make_path unless -d $parent_dir;
            $file->move_to($target_abs);
        }
    }

    if ($c->req->is_xhr) {
        return $c->render(json => { status => 'ok', count => scalar(@files) });
    }

    $c->redirect_to("/admin?tab=files&p=$sub_dir");
}

# POST /admin/file/rename
sub rename_file ($c) {
    my $target_rel = $sanitize_rel_path->($c->param('target_rel'));
    my $base_p     = $sanitize_rel_path->($c->param('base_p'));
    my $new_name   = $c->param('new_name') || '';

    $new_name =~ s{[\\/:*?"<>|]}{}g;
    $new_name =~ s{^\.+}{};
    return $c->redirect_to("/admin?tab=files&p=$base_p") unless length $new_name && length $target_rel;

    my $old_abs = $REPO_DIR->child($target_rel);
    my $new_abs = $old_abs->sibling($new_name);

    unless ($c->check_repo_boundary($old_abs) && $c->check_repo_boundary($new_abs)) {
        $c->flash(err => $c->l('Security Alert: Directory traversal detected.'));
        return $c->redirect_to("/admin?tab=files&p=$base_p");
    }

    if (my @slugs = $c->is_path_shared($target_rel)) {
        my $list = join(', ', map { "/$_/" } @slugs);
        $c->flash(err => $c->l('Modification prohibited: Resource actively occupied by [_1]. Revoke the share first.', $list));
        return $c->redirect_to("/admin?tab=files&p=$base_p");
    }

    if (-e $old_abs && !-e $new_abs) {
        rename($old_abs->to_string, $new_abs->to_string);
        $c->flash(msg => $c->l('Renamed to [_1] successfully.', $new_name));
    }

    $c->redirect_to("/admin?tab=files&p=$base_p");
}

# POST /admin/file/move
sub move_file ($c) {
    my $target_rel = $sanitize_rel_path->($c->param('target_rel'));
    my $dest_dir   = $sanitize_rel_path->($c->param('dest_dir'));
    my $base_p     = $sanitize_rel_path->($c->param('base_p'));

    if ($target_rel =~ m{(?:^|/)\.} || $dest_dir =~ m{(?:^|/)\.}) {
        $c->flash(err => $c->l('Security Alert: Access to hidden or system files is strictly restricted.'));
        return $c->redirect_to("/admin?tab=files&p=$base_p");
    }

    my $src_abs   = $REPO_DIR->child($target_rel);
    my $dest_base = length($dest_dir) ? $REPO_DIR->child($dest_dir) : $REPO_DIR;

    unless ($c->check_repo_boundary($src_abs) && $c->check_repo_boundary($dest_base)) {
        $c->flash(err => $c->l('Security Alert: Directory traversal detected.'));
        return $c->redirect_to("/admin?tab=files&p=$base_p");
    }

    if (my @slugs = $c->is_path_shared($target_rel)) {
        my $list = join(', ', map { "/$_/" } @slugs);
        $c->flash(err => $c->l('Move prohibited: Resource actively occupied by [_1]. Revoke share first.', $list));
        return $c->redirect_to("/admin?tab=files&p=$base_p");
    }

    unless (-e $src_abs && -d $dest_base) {
        $c->flash(err => $c->l('Move failed: Invalid source or destination path.'));
        return $c->redirect_to("/admin?tab=files&p=$base_p");
    }

    my $fname    = basename($src_abs->to_string);
    my $dest_abs = $dest_base->child($fname);

    if (-e $dest_abs) {
        $c->flash(err => $c->l('Move failed: Target entity [_1] already exists in destination.', $fname));
        return $c->redirect_to("/admin?tab=files&p=$base_p");
    }

    my $src_real  = realpath($src_abs->to_string);
    my $dest_real = realpath($dest_base->to_string);

    # Prevent moving a parent directory into its own child hierarchy
    if (index($dest_real, "$src_real/") == 0) {
        $c->flash(err => $c->l('Move failed: Cannot move a directory into its own subdirectory.'));
        return $c->redirect_to("/admin?tab=files&p=$base_p");
    }

    rename($src_abs->to_string, $dest_abs->to_string);
    $c->flash(msg => $c->l('Moved [_1] successfully.', $fname));
    $c->redirect_to("/admin?tab=files&p=$base_p");
}

# POST /admin/file/copy
sub copy_file ($c) {
    my $target_rel = $sanitize_rel_path->($c->param('target_rel'));
    my $dest_dir   = $sanitize_rel_path->($c->param('dest_dir'));
    my $base_p     = $sanitize_rel_path->($c->param('base_p'));

    if ($target_rel =~ m{(?:^|/)\.} || $dest_dir =~ m{(?:^|/)\.}) {
        $c->flash(err => $c->l('Security Alert: Access to hidden or system files is strictly restricted.'));
        return $c->redirect_to("/admin?tab=files&p=$base_p");
    }

    my $src_abs   = $REPO_DIR->child($target_rel);
    my $dest_base = length($dest_dir) ? $REPO_DIR->child($dest_dir) : $REPO_DIR;

    unless ($c->check_repo_boundary($src_abs) && $c->check_repo_boundary($dest_base)) {
        $c->flash(err => $c->l('Security Alert: Directory traversal detected.'));
        return $c->redirect_to("/admin?tab=files&p=$base_p");
    }

    unless (-e $src_abs && -d $dest_base) {
        $c->flash(err => $c->l('Copy failed: Invalid source or destination path.'));
        return $c->redirect_to("/admin?tab=files&p=$base_p");
    }

    my $fname    = basename($src_abs->to_string);
    my $dest_abs = $dest_base->child($fname);

    if (-e $dest_abs) {
        $c->flash(err => $c->l('Copy failed: Target entity [_1] already exists in destination.', $fname));
        return $c->redirect_to("/admin?tab=files&p=$base_p");
    }

    if (-d $src_abs) {
        dircopy($src_abs->to_string, $dest_abs->to_string);
    } else {
        fcopy($src_abs->to_string, $dest_abs->to_string);
    }

    $c->flash(msg => $c->l('Copied [_1] successfully.', $fname));
    $c->redirect_to("/admin?tab=files&p=$base_p");
}

# POST /admin/file/delete
sub delete_file ($c) {
    my $target_rel = $sanitize_rel_path->($c->param('target_rel'));
    my $base_p     = $sanitize_rel_path->($c->param('base_p'));
    my $abs        = $REPO_DIR->child($target_rel);

    unless (length($target_rel) && $c->check_repo_boundary($abs) && -e $abs) {
        $c->flash(err => $c->l('Security Alert: Unauthorized deletion path.'));
        return $c->redirect_to("/admin?tab=files&p=$base_p");
    }

    if (my @slugs = $c->is_path_shared($target_rel)) {
        my $list = join(', ', map { "/$_/" } @slugs);
        $c->flash(err => $c->l('Deletion prohibited: Resource actively occupied by [_1]. Revoke the share first.', $list));
        return $c->redirect_to("/admin?tab=files&p=$base_p");
    }

    my $fname = basename($abs->to_string);

    if (-d $abs) {
        remove_tree($abs->to_string);
        $c->flash(msg => $c->l('Directory [_1] deleted permanently.', $fname));
    } elsif (-f $abs) {
        unlink($abs->to_string);
        $c->flash(msg => $c->l('File [_1] deleted permanently.', $fname));
    }

    $c->redirect_to("/admin?tab=files&p=$base_p");
}

# -----------------------------------------------------------------------------
# Share Lifecycle Management
# -----------------------------------------------------------------------------

# POST /admin/share
sub create_share ($c) {
    my $target_rel = $sanitize_rel_path->($c->param('target_rel'));
    my $ttl_val    = int($c->param('ttl_val') // 0);
    my $ttl_unit   = $c->param('ttl_unit') // 'd';
    my $ttl        = $c->calc_ttl($ttl_val, $ttl_unit);
    my $password   = $c->param('password') // '';
    my $note       = $c->param('note')     // '';
    my $slug       = $c->param('slug')     // '';
    $slug =~ s/[^a-zA-Z0-9_\-]//g;

    if (length($slug) && $c->is_reserved_slug($slug)) {
        $c->flash(err => $c->l('The slug [_1] is a reserved system keyword.', $slug));
        return $c->redirect_to('/admin?tab=files');
    }

    $slug = $c->generate_slug() unless length $slug;
    $password =~ s/^\s+|\s+$//g;

    my $max_views = int($c->param('max_views') // 0);
    my $meta      = {
        slug          => $slug,
        target        => $target_rel,
        password      => $password,
        note          => $note,
        ttl_val       => $ttl_val,
        ttl_unit      => $ttl_unit,
        max_views     => $max_views,
        claimed_views => 0,
        expires_at    => $ttl > 0 ? (time() + $ttl) : 0,
        created_at    => time()
    };

    $DIR_ACTIVE->child("$slug.json")->spurt(encode_json($meta));
    $c->flash(created      => $slug);
    $c->flash(created_pwd  => $password);
    $c->flash(created_note => $note);
    $c->redirect_to('/admin?tab=actives');
}

# POST /admin/share/update
sub update_share ($c) {
    my $slug     = $c->param('slug');
    my $from     = $c->param('from') || 'active';
    my $ttl_val  = int($c->param('ttl_val') // 0);
    my $ttl_unit = $c->param('ttl_unit') // 'd';
    my $ttl      = $c->calc_ttl($ttl_val, $ttl_unit);
    my $password = $c->param('password');
    my $note     = $c->param('note') // '';
    my $src_file;

    my $primary_dir = (
          $from eq 'expired' ? $DIR_EXPIRED
        : $from eq 'trash'   ? $DIR_TRASH
        :                      $DIR_ACTIVE
    );

    for my $dir ($primary_dir, $DIR_EXPIRED, $DIR_TRASH, $DIR_ACTIVE) {
        my $f = $dir->child("$slug.json");
        if (-f $f) {
            $src_file = $f;
            last;
        }
    }

    unless ($src_file && -f $src_file) {
        $c->flash(err => $c->l('Share config [_1] not found anywhere.', $slug));
        return $c->redirect_to("/admin?tab=$from");
    }

    my $meta = eval { decode_json($src_file->slurp) };
    unless ($meta) {
        $c->flash(err => $c->l('Invalid JSON payload for [_1].', $slug));
        return $c->redirect_to("/admin?tab=$from");
    }

    my $target_check = $sanitize_rel_path->($c->param('target') || $meta->{target});
    my $target_abs   = $REPO_DIR->child($target_check);

    unless (-e $target_abs && $c->check_repo_boundary($target_abs)) {
        unlink($src_file->to_string);
        $c->flash(err => $c->l('Target [_1] missing on disk. Cleaned.', $target_check));
        return $c->redirect_to("/admin?tab=$from");
    }

    $meta->{target}     = $target_check;
    $meta->{ttl_val}    = $ttl_val;
    $meta->{ttl_unit}   = $ttl_unit;
    $meta->{expires_at} = $ttl > 0 ? (time() + $ttl) : 0;

    if (defined $c->param('max_views')) {
        my $new_max = int($c->param('max_views') // 0);
        $meta->{claimed_views} = 0 if $from ne 'active';
        $meta->{max_views}     = $new_max;
    }

    $meta->{note} = $note;

    if (defined $password) {
        $password =~ s/^\s+|\s+$//g;
        if ($password eq '__CLEAR__') {
            $meta->{password} = '';
        } elsif (length $password) {
            $meta->{password} = $password;
        }
    }

    my $dest_file = $DIR_ACTIVE->child("$slug.json");
    $dest_file->spurt(encode_json($meta));

    if ($src_file->to_string ne $dest_file->to_string) {
        unlink($src_file->to_string);
    }

    $c->flash(created      => $slug);
    $c->flash(created_pwd  => $meta->{password});
    $c->flash(created_note => $meta->{note});
    $c->redirect_to('/admin?tab=actives');
}

# POST /admin/share/action
sub share_action ($c) {
    my $slug    = $c->param('slug');
    my $action  = $c->param('action');
    my $from    = $c->param('from') || 'active';
    my $src_dir = $from eq 'expired' ? $DIR_EXPIRED : ($from eq 'trash' ? $DIR_TRASH : $DIR_ACTIVE);
    my $f       = $src_dir->child("$slug.json");

    if ($action eq 'trash') {
        if (-f $f) {
            $f->move_to($DIR_TRASH->child("$slug.json"));
            $c->flash(msg => $c->l('Share [_1] moved to Trash.', $slug));
        }
    } elsif ($action eq 'purge') {
        if (-f $f) {
            unlink($f->to_string);
            $c->flash(msg => $c->l('Share [_1] purged permanently.', $slug));
        }
    }

    $c->redirect_to("/admin?tab=$from");
}

# POST /admin/share/batch
sub batch_action ($c) {
    my $action = $c->param('action') || '';

    if ($action eq 'trash_selected') {
        my @slugs = @{ $c->every_param('slugs') };
        my $count = 0;

        for my $slug (@slugs) {
            $slug =~ s/[^a-zA-Z0-9_\-]//g;
            next unless length $slug;
            my $f = $DIR_EXPIRED->child("$slug.json");
            if (-f $f) {
                $f->move_to($DIR_TRASH->child("$slug.json"));
                $count++;
            }
        }

        $c->flash(msg => $c->l('Moved [_1] selected share(s) to Trash.', $count));
        return $c->redirect_to('/admin?tab=expired');
    } elsif ($action eq 'trash_all_expired') {
        my $count = 0;
        $DIR_EXPIRED->list->each(sub ($f, $num) {
            return unless $f =~ /\.json$/;
            $f->move_to($DIR_TRASH->child(basename($f)));
            $count++;
        });

        $c->flash(msg => $c->l('Moved [_1] expired shares to Trash.', $count));
        return $c->redirect_to('/admin?tab=trash');
    } elsif ($action eq 'purge_all_trash') {
        my $count = 0;
        $DIR_TRASH->list->each(sub ($f, $num) {
            return unless $f =~ /\.json$/;
            unlink $f->to_string;
            $count++;
        });

        $c->flash(msg => $c->l('Purged [_1] items permanently from Trash.', $count));
        return $c->redirect_to('/admin?tab=trash');
    }

    $c->redirect_to('/admin?tab=trash');
}

# -----------------------------------------------------------------------------
# AJAX Path Completion API
# -----------------------------------------------------------------------------

# GET /admin/api/paths
sub api_paths ($c) {
    my $q = $sanitize_rel_path->($c->param('q') // '');
    my ($dir_part, $name_prefix);

    if ($q =~ m{^(.*)/([^/]*)$}) {
        $dir_part    = $1;
        $name_prefix = lc($2);
    } else {
        $dir_part    = '';
        $name_prefix = lc($q);
    }

    my $scan_abs = $dir_part ? $REPO_DIR->child($dir_part) : $REPO_DIR;
    return $c->render(json => []) unless -d $scan_abs && $c->check_repo_boundary($scan_abs);

    my @matched;
    if (opendir(my $dh, $scan_abs->to_string)) {
        while (my $entry = readdir($dh)) {
            next if $entry =~ /^\./;
            $entry = decode_utf8($entry);

            if (!length($name_prefix) || index(lc($entry), $name_prefix) == 0) {
                my $entry_rel = $dir_part ? "$dir_part/$entry" : $entry;
                my $is_dir    = -d $scan_abs->child($entry);
                push @matched, {
                    val    => $is_dir ? "$entry_rel/" : $entry_rel,
                    label  => $entry_rel . ($is_dir ? '/' : ''),
                    is_dir => $is_dir ? 1 : 0
                };
                last if @matched >= 20;
            }
        }
        closedir($dh);
    }

    @matched = sort { $a->{val} cmp $b->{val} } @matched;
    return $c->render(json => \@matched);
}

1;