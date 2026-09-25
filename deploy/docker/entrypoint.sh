#!/bin/sh
#
# Fogshare - Container Entrypoint Supervisor
#
# Copyright (c) 2026 Fogshare Contributors
# Licensed under the MIT License.
#

set -e

# -----------------------------------------------------------------------------
# 1. Environment Variable Defaults
# -----------------------------------------------------------------------------
export HTTP_PORT="${HTTP_PORT:-3642}"
export ADMIN_DOMAIN="${APP_ADMIN_DOMAIN:-admin.localhost}"
export SHARE_DOMAIN="${APP_SHARE_DOMAIN:-localhost}"
export MAX_UPLOAD_MB="${APP_MAX_UPLOAD_MB:-128}"

# -----------------------------------------------------------------------------
# 2. Render Ingress Nginx Configuration
# -----------------------------------------------------------------------------
envsubst '${HTTP_PORT} ${ADMIN_DOMAIN} ${SHARE_DOMAIN} ${MAX_UPLOAD_MB}' \
    < /app/deploy/nginx/fogshare.conf.template > /etc/nginx/http.d/default.conf

# -----------------------------------------------------------------------------
# 3. Initialize & Self-Heal Storage Layout
# -----------------------------------------------------------------------------
mkdir -p /app/data/files \
         /app/data/libs \
         /app/data/share/active \
         /app/data/share/expired \
         /app/data/share/stats \
         /app/data/share/trash \
         /app/data/temp/limit

# Seed initial configuration from template if volume is fresh
if [ ! -f /app/data/fogshare.json ] && [ -f /app/config/fogshare.json.example ]; then
    cp /app/config/fogshare.json.example /app/data/fogshare.json
fi

# Ensure storage volume ownership belongs to the web runtime user
chown -R nginx:nginx /app/data

# -----------------------------------------------------------------------------
# 4. Launch Starman Application Server (Runs as nginx user)
# -----------------------------------------------------------------------------
echo "==> Starting Starman on 127.0.0.1:3647..."
su -s /bin/sh nginx -c "exec starman --listen 127.0.0.1:3647 --workers 4 /app/fogshared" &
STARMAN_PID=$!

# -----------------------------------------------------------------------------
# 5. Launch Nginx Reverse Proxy
# -----------------------------------------------------------------------------
echo "==> Starting Nginx frontend on port ${HTTP_PORT}..."
nginx -g "daemon off;" &
NGINX_PID=$!

# -----------------------------------------------------------------------------
# 6. Graceful Signal Trapping and Process Supervision
# -----------------------------------------------------------------------------
shutdown() {
    echo "==> Stopping Fogshare container services..."
    if kill -0 "$STARMAN_PID" 2>/dev/null; then
        kill -TERM "$STARMAN_PID" 2>/dev/null || true
    fi
    if kill -0 "$NGINX_PID" 2>/dev/null; then
        kill -TERM "$NGINX_PID" 2>/dev/null || true
    fi
    wait
    exit 0
}

trap shutdown SIGTERM SIGINT

# Wait for either service to exit prematurely and trigger teardown
wait -n "$STARMAN_PID" "$NGINX_PID"