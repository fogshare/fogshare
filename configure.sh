#!/usr/bin/env bash
#
# Fogshare - Clean Configuration & Deployment Generator
# Generates .env and Nginx vhost templates without modifying system state.
#
set -euo pipefail

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURRENT_DIR_NAME="$(basename "$APP_DIR")"

# Defaults & fallback variables
ADMIN_DOMAIN=""
SHARE_DOMAIN=""
LINK_MODE="subdomain"
BACKEND_PORT=3647
HTTP_PORT=80
MAX_UPLOAD_MB=128
DATA_DIR="$APP_DIR/data"
APP_USER="www-data"

show_help() {
    cat << EOF
Fogshare Instance Configuration Generator (CLI Flags / OPT)

Usage:
  ./configure.sh [options]

Core Options:
  -a, --admin-domain <domain>   Admin console domain (e.g., fogshare.lufeng.com)
  -s, --share-domain <domain>   Base domain for public shares (default: derived from admin domain)

Advanced Options:
  -m, --link-mode <mode>        Link routing mode: 'subdomain' or 'path' (default: subdomain)
  -p, --backend-port <port>     Starman internal listen port (default: 3647)
  -P, --http-port <port>        Nginx public listen port (default: 80)
  -u, --max-upload <mb>         Max request upload size in MB (default: 128)
  -d, --data-dir <path>         Persistent data storage directory (default: ./data)
  -U, --user <username>         Target system user for storage ownership (default: www-data)
  -h, --help                    Show this help message

Examples:
  ./configure.sh --admin-domain=fogshare.lufeng.com --share-domain=lufeng.com
  ./configure.sh (Fallback to admin.localhost / *.localhost)
EOF
    exit 0
}

# Parse CLI arguments (support short/long flags and = values)
while [[ $# -gt 0 ]]; do
    case "$1" in
        -a|--admin-domain)  ADMIN_DOMAIN="$2"; shift 2 ;;
        --admin-domain=*)   ADMIN_DOMAIN="${1#*=}"; shift 1 ;;
        -s|--share-domain)  SHARE_DOMAIN="$2"; shift 2 ;;
        --share-domain=*)   SHARE_DOMAIN="${1#*=}"; shift 1 ;;
        -m|--link-mode)     LINK_MODE="$2"; shift 2 ;;
        --link-mode=*)      LINK_MODE="${1#*=}"; shift 1 ;;
        -p|--backend-port)  BACKEND_PORT="$2"; shift 2 ;;
        --backend-port=*)   BACKEND_PORT="${1#*=}"; shift 1 ;;
        -P|--http-port)     HTTP_PORT="$2"; shift 2 ;;
        --http-port=*)      HTTP_PORT="${1#*=}"; shift 1 ;;
        -u|--max-upload)    MAX_UPLOAD_MB="$2"; shift 2 ;;
        --max-upload=*)     MAX_UPLOAD_MB="${1#*=}"; shift 1 ;;
        -d|--data-dir)      DATA_DIR="$2"; shift 2 ;;
        --data-dir=*)       DATA_DIR="${1#*=}"; shift 1 ;;
        -U|--user)          APP_USER="$2"; shift 2 ;;
        --user=*)           APP_USER="${1#*=}"; shift 1 ;;
        -h|--help)          show_help ;;
        *)
            printf "\033[1;31m[ERROR]\033[0m Unknown option: %s\n" "$1"
            exit 1
            ;;
    esac
done

IS_FALLBACK=0
if [[ -z "$ADMIN_DOMAIN" ]]; then
    IS_FALLBACK=1
    ADMIN_DOMAIN="admin.localhost"
    SHARE_DOMAIN="localhost"
else
    if [[ -z "$SHARE_DOMAIN" ]]; then
        if [[ "$ADMIN_DOMAIN" =~ \. ]]; then
            SHARE_DOMAIN="${ADMIN_DOMAIN#*.}"
        else
            SHARE_DOMAIN="$ADMIN_DOMAIN"
        fi
    fi
fi

# 1. Generate local .env file
ENV_FILE="$APP_DIR/.env"
cat << EOF > "$ENV_FILE"
# Fogshare Node Configuration
# Generated via configure.sh on $(date)

APP_ADMIN_DOMAIN=$ADMIN_DOMAIN
APP_SHARE_DOMAIN=$SHARE_DOMAIN
APP_LINK_MODE=$LINK_MODE
APP_MAX_UPLOAD_MB=$MAX_UPLOAD_MB
APP_DATA_DIR=$DATA_DIR
APP_CONFIG=$DATA_DIR/fogshare.json
APP_PASSWD_FILE=$DATA_DIR/passwd.json
APP_BACKEND_PORT=$BACKEND_PORT
MOJO_REVERSE_PROXY=1
MOJO_MODE=production
EOF

# 2. Initialize local data directory skeleton
mkdir -p "$DATA_DIR/files" "$DATA_DIR/libs" "$DATA_DIR/share/active" \
         "$DATA_DIR/share/expired" "$DATA_DIR/share/trash" "$DATA_DIR/share/stats" \
         "$DATA_DIR/temp/limit"

# 3. Render Nginx virtual host configuration
NGINX_TEMPLATE="$APP_DIR/deploy/nginx/fogshare.conf.template"
NGINX_OUT="$APP_DIR/fogshare.nginx.conf"

if [[ -f "$NGINX_TEMPLATE" ]]; then
    export ADMIN_DOMAIN SHARE_DOMAIN HTTP_PORT BACKEND_PORT MAX_UPLOAD_MB DATA_DIR APP_DIR
    perl -pe 's/\$\{(\w+)\}/$ENV{$1} \/\/ $&/ge' "$NGINX_TEMPLATE" > "$NGINX_OUT"
fi

# 4. Print setup instructions
printf "\n\033[1;32m==================================================\033[0m\n"
printf "\033[1;32m      Fogshare Instance Configuration Ready       \033[0m\n"
printf "\033[1;32m==================================================\033[0m\n\n"

if [[ "$IS_FALLBACK" -eq 1 ]]; then
    printf "\033[1;33m[NOTICE]\033[0m No --admin-domain specified.\n"
    printf "         Using local demonstration fallback:\n"
    printf "         - Admin Domain : http://admin.localhost:%s\n" "$HTTP_PORT"
    printf "         - Share Base   : *.localhost\n\n"
else
    printf "\033[1;34m[CONFIG]\033[0m Derived parameters:\n"
    printf "         - Admin Domain : %s\n" "$ADMIN_DOMAIN"
    printf "         - Share Domain : %s (*.%s)\n" "$SHARE_DOMAIN" "$SHARE_DOMAIN"
    printf "         - Backend Port : 127.0.0.1:%s\n" "$BACKEND_PORT"
    printf "         - Data Storage : %s\n\n" "$DATA_DIR"
fi

printf "Artifacts Generated:\n"
printf "  [1] Environment  : %s\n" "$ENV_FILE"
printf "  [2] Nginx Config : %s\n\n" "$NGINX_OUT"

printf "\033[1;37mNext Steps (Manual Execution Guide):\033[0m\n"
printf "  1. Permissions:\n"
printf "     sudo chown -R %s:%s \"%s\"\n\n" "$APP_USER" "$APP_USER" "$DATA_DIR"
printf "  2. Nginx Setup:\n"
printf "     sudo ln -sf \"%s\" /etc/nginx/sites-enabled/%s.conf\n" "$NGINX_OUT" "$ADMIN_DOMAIN"
printf "     sudo nginx -t && sudo systemctl reload nginx\n\n"
printf "  3. Service Management:\n"
printf "     - Standalone Unit:\n"
printf "       sudo cp \"%s/deploy/systemd/fogshare.service\" /etc/systemd/system/\n" "$APP_DIR"
printf "       sudo systemctl enable --now fogshare\n"
printf "     - Multi-Tenant Template:\n"
printf "       sudo cp \"%s/deploy/systemd/fogshare@.service\" /etc/systemd/system/\n" "$APP_DIR"
printf "       sudo systemctl enable --now fogshare@%s\n\n" "$ADMIN_DOMAIN"