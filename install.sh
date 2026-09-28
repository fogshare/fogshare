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
BACKEND_PORT=3647
HTTP_PORT=80
CPANM_BIN=""
REPO_URL="https://github.com/fogshare/fogshare.git"

show_banner() {
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
        *)
            DISTRO="unknown"
            ;;
    esac
    log_info "Detected OS: $OS_TYPE ($DISTRO)"
}

detect_perl_flavor() {
    if ! command -v perl >/dev/null 2>&1; then
        PERL_FLAVOR="none"
        return
    fi
    PERL_BIN="$(command -v perl)"
    if echo "$PERL_BIN" | grep -qE "(perlbrew|plenv|asdf|/\.local/)"; then
        PERL_FLAVOR="custom"
    else
        PERL_FLAVOR="system"
    fi
    log_info "Active Perl interpreter: $PERL_BIN"
}

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
        log_info "Installing missing Perl modules via cpanm:$MISSING_MODULES"
        ensure_cpanm
        $CPANM_BIN --notest $MISSING_MODULES
    fi
}

install_dependencies() {
    if [ "$PERL_FLAVOR" = "custom" ]; then
        ensure_cpanm
        $CPANM_BIN --notest Mojolicious Starman Digest::SHA Archive::Zip Mojolicious::Plugin::I18N File::Copy::Recursive
        return
    fi

    log_info "Installing OS and runtime packages..."
    case "$DISTRO" in
        ubuntu|debian)
            export DEBIAN_FRONTEND=noninteractive
            apt-get update -qy
            apt-get install -qy curl git make gcc build-essential nginx \
                perl libmojolicious-perl starman libdigest-sha-perl \
                libarchive-zip-perl libfile-copy-recursive-perl || true
            ;;
        rhel|centos|rocky|almalinux|fedora)
            PKG_MGR="yum"
            command -v dnf >/dev/null 2>&1 && PKG_MGR="dnf"
            $PKG_MGR install -y gcc make git curl nginx perl perl-core perl-App-cpanminus \
                perl-Digest-SHA perl-Archive-Zip || true
            ;;
        alpine)
            apk update
            apk add --no-cache curl git build-base nginx perl perl-dev perl-app-cpanminus linux-headers
            ;;
        freebsd)
            pkg install -y git nginx perl5 p5-Mojolicious p5-Starman p5-Archive-Zip p5-Digest-SHA
            ;;
    esac

    check_and_fallback_cpanm
}

setup_user_and_dirs() {
    if ! id "$APP_USER" >/dev/null 2>&1; then
        log_info "Creating system service user: $APP_USER"
        if [ "$DISTRO" = "freebsd" ]; then
            pw useradd "$APP_USER" -d "$INSTALL_DIR" -s /usr/sbin/nologin -c "Fogshare Service"
        elif command -v useradd >/dev/null 2>&1; then
            useradd -r -s /sbin/nologin -d "$INSTALL_DIR" "$APP_USER"
        else
            adduser -S -D -H -h "$INSTALL_DIR" -s /sbin/nologin "$APP_USER"
        fi
    fi

    mkdir -p "$INSTALL_DIR"

    # Deploy application sources
    if [ -f "./fogshared" ] && [ "$(pwd)" != "$INSTALL_DIR" ]; then
        log_info "Deploying local repository tree to $INSTALL_DIR..."
        cp -R bin config deploy lib public templates fogshared configure.sh cpanfile "$INSTALL_DIR/"
    elif [ ! -f "$INSTALL_DIR/fogshared" ]; then
        log_info "Fetching sources from $REPO_URL..."
        TMP_CLONE_DIR="$(mktemp -d)"
        git clone --depth=1 "$REPO_URL" "$TMP_CLONE_DIR"
        cp -R "$TMP_CLONE_DIR/bin" "$TMP_CLONE_DIR/config" "$TMP_CLONE_DIR/deploy" \
              "$TMP_CLONE_DIR/lib" "$TMP_CLONE_DIR/public" "$TMP_CLONE_DIR/templates" \
              "$TMP_CLONE_DIR/fogshared" "$TMP_CLONE_DIR/configure.sh" \
              "$TMP_CLONE_DIR/cpanfile" "$INSTALL_DIR/"
        rm -rf "$TMP_CLONE_DIR"
    fi

    chmod +x "$INSTALL_DIR/fogshared" "$INSTALL_DIR/bin/"* "$INSTALL_DIR/configure.sh"

    # Execute configure.sh non-interactively to generate .env, storage skeleton, and nginx.conf
    log_info "Generating configuration and local artifacts..."
    (
        cd "$INSTALL_DIR"
        ./configure.sh \
            --admin-domain="admin.localhost" \
            --share-domain="localhost" \
            --backend-port="$BACKEND_PORT" \
            --http-port="$HTTP_PORT" \
            --data-dir="$INSTALL_DIR/data" \
            --user="$APP_USER"
    )

    if [ ! -f "$INSTALL_DIR/data/fogshare.json" ] && [ -f "$INSTALL_DIR/config/fogshare.json.example" ]; then
        cp "$INSTALL_DIR/config/fogshare.json.example" "$INSTALL_DIR/data/fogshare.json"
    fi

    chown -R "$APP_USER:$APP_USER" "$INSTALL_DIR"
}

setup_services() {
    # 1. Setup Nginx Virtual Host
    if [ -f "$INSTALL_DIR/fogshare.nginx.conf" ] && [ -d /etc/nginx ]; then
        log_info "Deploying Nginx reverse proxy configuration..."
        NGINX_TARGET="/etc/nginx/conf.d/fogshare.conf"
        [ -d /etc/nginx/sites-enabled ] && NGINX_TARGET="/etc/nginx/sites-enabled/fogshare.conf"
        cp "$INSTALL_DIR/fogshare.nginx.conf" "$NGINX_TARGET"

        if command -v nginx >/dev/null 2>&1; then
            nginx -t && (systemctl reload nginx 2>/dev/null || nginx -s reload 2>/dev/null || true)
        fi
    fi

    # 2. Setup Systemd Service Unit
    if [ -d /run/systemd/system ] && command -v systemctl >/dev/null 2>&1; then
        log_info "Registering Systemd service unit..."
        cp "$INSTALL_DIR/deploy/systemd/fogshare.service" /etc/systemd/system/fogshare.service
        systemctl daemon-reload
        systemctl enable --now fogshare.service
        log_info "Fogshare system service started successfully."
    else
        log_warn "Systemd not detected. Run manually:"
        log_info "  su -s /bin/sh $APP_USER -c 'starman --port $BACKEND_PORT --workers 4 $INSTALL_DIR/fogshared &'"
    fi
}

main() {
    show_banner
    check_privileges
    detect_platform
    detect_perl_flavor
    install_dependencies
    setup_user_and_dirs
    setup_services

    printf "\n\033[1;32m====================================================\033[0m\n"
    printf "\033[1;32m      Fogshare Deployment Completed Successfully    \033[0m\n"
    printf "\033[1;32m====================================================\033[0m\n\n"
    printf "Default Ingress Endpoints:\n"
    printf "  - Admin Console : http://admin.localhost:%s/\n" "$HTTP_PORT"
    printf "  - Public Node   : http://localhost:%s/\n\n" "$HTTP_PORT"
    printf "Configuration file located at: %s/.env\n\n" "$INSTALL_DIR"
}

main "$@"