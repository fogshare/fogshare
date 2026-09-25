package Fogshare::Context;
#
# Fogshare - Context and Runtime Configuration
#
# Copyright (c) 2026 Fogshare Contributors
# Licensed under the MIT License.
#

use Mojo::Base -strict, -signatures;
use Mojo::File  qw(path);
use Mojo::JSON  qw(decode_json encode_json);
use Digest::SHA qw(hmac_sha256_hex);
use Fcntl       qw(:flock);
use FindBin;
use Exporter    'import';

our @EXPORT = qw(
    $CONFIG $CONFIG_FILE $PASSWD_FILE $SECRET_KEY $API_TOKEN $ENABLE_X_ACCEL
    $MAX_UPLOAD_MB $MAX_UNZIP_BYTES $MAX_ZIP_ENTRIES $MAX_COMPRESSION_RATIO
    $BASE_DIR $REPO_DIR $SHARED_LIBS $SHARES_DIR $DIR_ACTIVE $DIR_EXPIRED
    $DIR_TRASH $DIR_STATS $SHM_DIR $RESERVED_SLUGS_RE
    $LINK_MODE $ADMIN_DOMAIN $SHARE_DOMAIN
    $SITE_NAME $FAVICON_URL $LOGO_URL
    $FOOTER_HTML $CUSTOM_CSS $CUSTOM_JS
    init_app_context
);

# Application root discovery (handles both bin and lib/t directory setups)
my $APP_ROOT = path($FindBin::Bin);
$APP_ROOT = $APP_ROOT->parent if $APP_ROOT->basename eq 'lib' || $APP_ROOT->basename eq 't';

# Storage paths: defaults to ./data relative to execution context
our $BASE_DIR    = path($ENV{APP_DATA_DIR} || './data')->to_abs;
our $REPO_DIR    = $BASE_DIR->child('files')->make_path;
our $SHARED_LIBS = $BASE_DIR->child('libs')->make_path;
our $SHARES_DIR  = $BASE_DIR->child('share');
our $DIR_ACTIVE  = $SHARES_DIR->child('active')->make_path;
our $DIR_EXPIRED = $SHARES_DIR->child('expired')->make_path;
our $DIR_TRASH   = $SHARES_DIR->child('trash')->make_path;
our $DIR_STATS   = $SHARES_DIR->child('stats')->make_path;

# Configuration & limits: strictly scoped to $BASE_DIR
our $CONFIG_FILE   = path($ENV{APP_CONFIG} || $BASE_DIR->child('fogshare.json'));
our $CONFIG        = -f $CONFIG_FILE ? eval { decode_json($CONFIG_FILE->slurp) } || {} : {};
our $MAX_UPLOAD_MB = $CONFIG->{max_upload_mb} || 128;
$ENV{MOJO_MAX_MESSAGE_SIZE} = $MAX_UPLOAD_MB * 1024 * 1024;

# Domain and routing modes
our $LINK_MODE    = $ENV{APP_LINK_MODE}    || $CONFIG->{link_mode}    || 'path';
our $ADMIN_DOMAIN = $ENV{APP_ADMIN_DOMAIN} || $CONFIG->{admin_domain} || 'localhost';
our $SHARE_DOMAIN = $ENV{APP_SHARE_DOMAIN} || $CONFIG->{share_domain} || $ADMIN_DOMAIN;

# ZIP unpack limits
our $MAX_UNZIP_BYTES       = $CONFIG->{max_unzip_mb} ? ($CONFIG->{max_unzip_mb} * 1024 * 1024) : (512 * 1024 * 1024);
our $MAX_ZIP_ENTRIES       = $CONFIG->{max_zip_entries} || 10000;
our $MAX_COMPRESSION_RATIO = 100;

# Rate limit storage: prioritize /dev/shm with restrictive permissions, fallback to isolated data directory
our $SHM_DIR = (-d '/dev/shm' && -w '/dev/shm')
    ? path('/dev/shm')->child("fogshare_${<}_limit")->make_path
    : $BASE_DIR->child('temp', 'limit')->make_path;
eval { chmod 0700, $SHM_DIR->to_string };

# Generate cryptographically secure or pseudo-random token
my $_generate_csprng_token = sub ($salt_tag, $length = 16) {
    my @chars = ('2' .. '9', 'a' .. 'k', 'm' .. 'z', 'A' .. 'H', 'J' .. 'N', 'P' .. 'Z');
    my $bytes = '';

    if (-e '/dev/urandom' && open my $rfh, '<:raw', '/dev/urandom') {
        read($rfh, $bytes, $length);
        close $rfh;
    }

    # Fallback to high-resolution timestamp & process seed hashing
    unless (defined $bytes && length($bytes) == $length) {
        require Time::HiRes;
        require Digest::SHA;
        $bytes = '';
        while (length($bytes) < $length) {
            my $seed = join('|', $$, Time::HiRes::time(), {}, rand(), $ENV{HOSTNAME} || '', $salt_tag, length($bytes));
            $bytes .= Digest::SHA::hmac_sha256($seed, pack('N*', CORE::time(), $$, rand(0xFFFFFFFF)));
        }
        $bytes = substr($bytes, 0, $length);
    }

    return join '', map { $chars[ord($_) % scalar(@chars)] } split //, $bytes;
};

# Securely resolve or persist unique token/secret into fogshare.json with exclusive file lock
my $_resolve_or_generate_secret = sub ($provided, $config_key, $salt_tag) {
    return $provided if defined $provided && length $provided;

    my $secret;

    if (open my $fh, '+>>', $CONFIG_FILE->to_string) {
        flock($fh, LOCK_EX);
        seek($fh, 0, 0);

        my $raw      = do { local $/; <$fh> };
        my $disk_cfg = eval { decode_json($raw) } || {};

        if (defined $disk_cfg->{$config_key} && length $disk_cfg->{$config_key}) {
            $secret = $disk_cfg->{$config_key};
        } else {
            $secret                  = $_generate_csprng_token->($salt_tag, 32);
            $disk_cfg->{$config_key} = $secret;
            $CONFIG->{$config_key}   = $secret;

            seek($fh, 0, 0);
            truncate($fh, 0);
            print $fh encode_json($disk_cfg);
            chmod 0600, $CONFIG_FILE->to_string;
        }

        flock($fh, LOCK_UN);
        close $fh;
    }

    return $secret // '';
};

# Application secret and API token resolution
our $SECRET_KEY = $_resolve_or_generate_secret->($ENV{APP_SECRET},    'app_secret', 'app_secret');
our $API_TOKEN  = $_resolve_or_generate_secret->($ENV{APP_API_TOKEN}, 'api_token',  'api_token');

our $ENABLE_X_ACCEL = $CONFIG->{enable_x_accel} // 0;

# Password file: strictly scoped to $BASE_DIR
our $PASSWD_FILE = path($ENV{APP_PASSWD_FILE} || $BASE_DIR->child('passwd.json'));

our $RESERVED_SLUGS_RE = qr/^(?:admin|api|libs)$/i;

# Branding and UI customization
our $SITE_NAME   = $ENV{APP_SITE_NAME}   || $CONFIG->{site_name}   || 'Fogshare';
our $FAVICON_URL = $ENV{APP_FAVICON_URL} || $CONFIG->{favicon_url} || '/favicon.ico';
our $LOGO_URL    = $ENV{APP_LOGO_URL}    || $CONFIG->{logo_url}    || '/logo.svg';

our $FOOTER_HTML = $ENV{APP_FOOTER_HTML} || $CONFIG->{footer_html} || '';
our $CUSTOM_CSS  = $ENV{APP_CUSTOM_CSS}  || $CONFIG->{custom_css}  || '';
our $CUSTOM_JS   = $ENV{APP_CUSTOM_JS}   || $CONFIG->{custom_js}   || '';

# Initialize core Mojolicious settings and session security
sub init_app_context ($app) {
    $app->renderer->paths([$APP_ROOT->child('templates')->to_string]);
    $app->secrets([$SECRET_KEY]);
    $app->sessions->cookie_name('fogshare_session');
    $app->sessions->cookie_path('/');
    $app->sessions->default_expiration(86400 * 7);
    $app->sessions->samesite('Lax');

    # Enforce RFC 6265 Host-Only session cookies
    $app->sessions->cookie_domain(undef);

    # Static HTTPS enforcement determined at boot
    my $enable_https = exists $ENV{APP_ENABLE_HTTPS} ? $ENV{APP_ENABLE_HTTPS} : ($CONFIG->{enable_https} // 0);
    $app->sessions->secure(1) if $enable_https;

    bootstrap_admin_account();
}

# Ensure administrative credentials are bootstrapped with salted hash
sub bootstrap_admin_account () {
    my $pass_file = $PASSWD_FILE->to_string;

    # Open file in read/write append mode and acquire exclusive lock
    if (open my $fh, '+>>', $pass_file) {
        flock($fh, LOCK_EX);
        seek($fh, 0, 0);

        my $raw      = do { local $/; <$fh> };
        my $accounts = eval { decode_json($raw) } || {};

        # If accounts already exist (persisted or populated by another worker), release and return
        if (keys %$accounts) {
            flock($fh, LOCK_UN);
            close $fh;
            return;
        }

        my $initial_pass = $ENV{APP_ADMIN_PASS};
        my $is_generated = 0;

        unless (defined $initial_pass && length $initial_pass) {
            $initial_pass = $_generate_csprng_token->('admin_init_pass', 16);
            $is_generated = 1;
        }

        # Store salted SHA-256 password hash
        my $salted_hash = hmac_sha256_hex($initial_pass, $SECRET_KEY);
        $accounts = { admin => $salted_hash };

        seek($fh, 0, 0);
        truncate($fh, 0);
        print $fh encode_json($accounts);
        chmod 0600, $pass_file;

        flock($fh, LOCK_UN);
        close $fh;

        if ($is_generated) {
            warn "\n" . ('=' x 70) . "\n";
            warn "[Fogshare Security Alert] First boot initialization:\n";
            warn "  Default Administrator Username : admin\n";
            warn "  Generated Initial Password     : $initial_pass\n";
            warn "  Please log in and update your password immediately.\n";
            warn ('=' x 70) . "\n\n";
        }
    }
}

1;