#!/bin/sh
#
# Fogshare - Bare-Metal / Host Environment Installer
#
# Copyright (c) 2026 Fogshare Contributors
# Licensed under the MIT License.
#

set -eu

INSTALL_DIR="/opt/fogshare"
APP_USER="fogshare"
APP_PORT=3647
CPANM_BIN=""
REPO_URL="https://github.com/fogshare/fogshare.git"

# -----------------------------------------------------------------------------
# Terminal UI & Banner Utilities
# -----------------------------------------------------------------------------
show_banner() {
    # DEC VT100 classic double-height hardware character expansion
    # Clears screen, positions cursor, and emits top/bottom lines in cyan bold
    if [ -t 1 ]; then
        printf "\033[2J\033[1;1H"
        printf "\033[1;36m"
        printf "\033#3  Fogshare\n"
        printf "\033#4  Fogshare\n"
        printf "\033[0m"
        printf "\033[1;30m  Ephemeral File-Sharing & Showcase Engine\033[0m\n\n"
    else
        printf "\n--- Fogshare Installation ---\n\n"
    fi
}

log_info()  { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
log_warn()  { printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }
log_error() { printf "\033[1;31m[ERROR]\033[0m %s\n" "$*"; exit 1; }

# -----------------------------------------------------------------------------
# 1. Privilege & Platform Detection
# -----------------------------------------------------------------------------
check_privileges() {
    if [ "$(id -u)" -ne 0 ]; then
        log_error "This installation script must be run as root or via sudo."
    fi
}

detect_platform() {
    OS_TYPE="$(uname -s)"
    DISTRO="unknown"

    case "$OS_TYPE" in
        Linux)
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                DISTRO="${ID:-linux}"
            fi
            ;;
        FreeBSD)
            DISTRO="freebsd"
            ;;
        Darwin)
            DISTRO="darwin"
            ;;
        *)
            DISTRO="unknown"
            ;;
    esac
    log_info "Detected OS: $OS_TYPE, Distribution/Flavor: $DISTRO"
}

# -----------------------------------------------------------------------------
# 2. Perl Flavor & Runtime Detection
# -----------------------------------------------------------------------------
detect_perl_flavor() {
    if ! command -v perl >/dev/null 2>&1; then
        PERL_FLAVOR="none"
        log_warn "No active Perl interpreter found in system PATH."
        return
    fi

    PERL_BIN="$(command -v perl)"
    if echo "$PERL_BIN" | grep -qE "(perlbrew|plenv|asdf|/\.local/)"; then
        PERL_FLAVOR="custom"
    elif [ "$PERL_BIN" = "/usr/local/bin/perl" ] && [ "$DISTRO" != "freebsd" ]; then
        PERL_FLAVOR="custom"
    else
        PERL_FLAVOR="system"
    fi
    log_info "Active Perl: $PERL_BIN (Flavor: $PERL_FLAVOR)"
}

# -----------------------------------------------------------------------------
# 3. Dependency Management & Bootstrapping
# -----------------------------------------------------------------------------
ensure_cpanm() {
    if command -v cpanm >/dev/null 2>&1; then
        CPANM_BIN="$(command -v cpanm)"
    else
        log_info "Bootstrapping standalone cpanm binary..."
        curl -fsSL https://cpanmin.us -o /usr/local/bin/cpanm || log_error "Failed to fetch cpanm installer."
        chmod +x /usr/local/bin/cpanm
        CPANM_BIN="/usr/local/bin/cpanm"
    fi
}

check_and_fallback_cpanm() {
    MISSING_MODULES=""
    for mod in "Mojolicious" "Starman" "Archive::Zip" "Digest::SHA" "Mojolicious::Plugin::I18N" "File::Copy::Recursive"; do
        if ! perl -M"$mod" -e 1 2>/dev/null; then
            MISSING_MODULES="$MISSING_MODULES $mod"
        fi
    done

    if [ -n "$MISSING_MODULES" ]; then
        log_info "Installing missing dependencies via cpanm:$MISSING_MODULES"
        ensure_cpanm
        $CPANM_BIN --notest $MISSING_MODULES
    fi
}

install_dependencies() {
    if [ "$PERL_FLAVOR" = "custom" ]; then
        log_info "Custom Perl detected. Installing application dependencies via cpanm..."
        ensure_cpanm
        $CPANM_BIN --notest Mojolicious Starman Digest::SHA Archive::Zip Mojolicious::Plugin::I18N File::Copy::Recursive
        return
    fi

    log_info "Using platform package manager to install runtime dependencies..."
    case "$DISTRO" in
        ubuntu|debian)
            export DEBIAN_FRONTEND=noninteractive
            apt-get update -qy
            apt-get install -qy curl git make gcc build-essential \
                perl libmojolicious-perl starman libdigest-sha-perl \
                libarchive-zip-perl libfile-copy-recursive-perl || true
            ;;
        rhel|centos|rocky|almalinux|fedora)
            PKG_MGR="yum"
            command -v dnf >/dev/null 2>&1 && PKG_MGR="dnf"
            $PKG_MGR install -y gcc make git curl perl perl-core perl-App-cpanminus \
                perl-Digest-SHA perl-Archive-Zip || true
            ;;
        alpine)
            apk update
            apk add --no-cache curl git build-base perl perl-dev perl-app-cpanminus linux-headers
            ;;
        freebsd)
            pkg install -y git perl5 p5-Mojolicious p5-Starman p5-Archive-Zip p5-Digest-SHA
            ;;
        darwin)
            log_warn "macOS detected. Please ensure command line tools and cpanm are installed."
            ;;
    esac

    check_and_fallback_cpanm
}

# -----------------------------------------------------------------------------
# 4. User Provisioning & Filesystem Layout
# -----------------------------------------------------------------------------
setup_user_and_dirs() {
    if ! id "$APP_USER" >/dev/null 2>&1; then
        log_info "Creating system user: $APP_USER"
        if [ "$DISTRO" = "freebsd" ]; then
            pw useradd "$APP_USER" -d "$INSTALL_DIR" -s /usr/sbin/nologin -c "Fogshare Service"
        elif command -v useradd >/dev/null 2>&1; then
            useradd -r -s /sbin/nologin -d "$INSTALL_DIR" "$APP_USER"
        else
            adduser -S -D -H -h "$INSTALL_DIR" -s /sbin/nologin "$APP_USER"
        fi
    fi

    mkdir -p "$INSTALL_DIR" \
             "$INSTALL_DIR/data/files" \
             "$INSTALL_DIR/data/libs" \
             "$INSTALL_DIR/data/share/active" \
             "$INSTALL_DIR/data/share/expired" \
             "$INSTALL_DIR/data/share/stats" \
             "$INSTALL_DIR/data/share/trash" \
             "$INSTALL_DIR/data/temp/limit"

    # Deploy application sources: prioritize local tree, fallback to remote git clone
    if [ -f "./fogshared" ] && [ "$(pwd)" != "$INSTALL_DIR" ]; then
        log_info "Deploying local repository assets to $INSTALL_DIR..."
        cp -R bin config lib public templates fogshared cpanfile "$INSTALL_DIR/"
    elif [ ! -f "$INSTALL_DIR/fogshared" ]; then
        log_info "No local files found. Cloning repository from $REPO_URL..."
        TMP_CLONE_DIR="$(mktemp -d)"
        git clone --depth=1 "$REPO_URL" "$TMP_CLONE_DIR"
        cp -R "$TMP_CLONE_DIR/bin" "$TMP_CLONE_DIR/config" "$TMP_CLONE_DIR/lib" \
              "$TMP_CLONE_DIR/public" "$TMP_CLONE_DIR/templates" \
              "$TMP_CLONE_DIR/fogshared" "$TMP_CLONE_DIR/cpanfile" "$INSTALL_DIR/"
        rm -rf "$TMP_CLONE_DIR"
    fi

    chmod +x "$INSTALL_DIR/fogshared" "$INSTALL_DIR/bin/"*

    # Seed configuration template if absent
    if [ ! -f "$INSTALL_DIR/data/fogshare.json" ] && [ -f "$INSTALL_DIR/config/fogshare.json.example" ]; then
        cp "$INSTALL_DIR/config/fogshare.json.example" "$INSTALL_DIR/data/fogshare.json"
    fi

    chown -R "$APP_USER:$APP_USER" "$INSTALL_DIR"
}

# -----------------------------------------------------------------------------
# 5. Service Supervision Setup (Systemd with graceful fallback)
# -----------------------------------------------------------------------------
setup_init_service() {
    if [ -d /run/systemd/system ] && command -v systemctl >/dev/null 2>&1; then
        log_info "Registering Systemd service unit..."
        STARMAN_BIN="$(command -v starman)"

        cat << EOF > /etc/systemd/system/fogshare.service
#
# Fogshare - Systemd Service Unit
# Generated by install.sh
#

[Unit]
Description=Fogshare Self-Hosted Ephemeral File-Sharing Engine
After=network.target

[Service]
Type=simple
User=$APP_USER
Group=$APP_USER
WorkingDirectory=$INSTALL_DIR
Environment="MOJO_MODE=production"
Environment="MOJO_REVERSE_PROXY=1"
Environment="APP_DATA_DIR=$INSTALL_DIR/data"
Environment="APP_CONFIG=$INSTALL_DIR/data/fogshare.json"
Environment="APP_PASSWD_FILE=$INSTALL_DIR/data/passwd.json"
ExecStart=$STARMAN_BIN --workers 4 --port $APP_PORT $INSTALL_DIR/fogshared
ExecReload=/bin/kill -HUP \$MAINPID
Restart=always
RestartSec=5
LimitNOFILE=65535
StandardOutput=journal
StandardError=journal
SyslogIdentifier=fogshare

[Install]
WantedBy=multi-user.target
EOF

        systemctl daemon-reload
        systemctl enable --now fogshare.service
        log_info "Service successfully enabled and started via systemctl."
    else
        log_warn "Systemd is not active in this environment."
        log_info "You can start Fogshare manually with:"
        log_info "  su -s /bin/sh $APP_USER -c 'starman --port $APP_PORT --workers 4 $INSTALL_DIR/fogshared &'"
    fi
}

# -----------------------------------------------------------------------------
# Main Execution Flow
# -----------------------------------------------------------------------------
main() {
    show_banner
    check_privileges
    detect_platform
    detect_perl_flavor
    install_dependencies
    setup_user_and_dirs
    setup_init_service
    log_info "Fogshare deployment completed successfully! Listening on port $APP_PORT."
}

main "$@"