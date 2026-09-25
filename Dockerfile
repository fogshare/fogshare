#
# Fogshare - Container Deployment Definition (Multi-Stage Build)
#
# Copyright (c) 2026 Fogshare Contributors
# Licensed under the MIT License.
#

# =============================================================================
# Stage 1: Build & Dependency Resolution Environment
# =============================================================================
FROM alpine:3.20 AS builder

RUN apk add --no-cache \
    build-base \
    linux-headers \
    perl \
    perl-app-cpanminus \
    perl-dev

WORKDIR /app
COPY cpanfile /app/

# Install Perl dependencies into an isolated local vendor tree
RUN cpanm --notest --local-lib-contained /app/local --installdeps .

# =============================================================================
# Stage 2: Minimal Production Runtime
# =============================================================================
FROM alpine:3.20

LABEL org.opencontainers.image.title="Fogshare" \
      org.opencontainers.image.description="Self-hosted ephemeral file-sharing engine powered by Mojolicious" \
      org.opencontainers.image.licenses="MIT"

RUN apk add --no-cache \
    ca-certificates \
    gettext \
    nginx \
    perl \
    tzdata

WORKDIR /app

# Copy pre-built isolated Perl library tree
COPY --from=builder /app/local /app/local

# Register local Perl library directory in runtime lookup paths
ENV PERL5LIB="/app/local/lib/perl5:${PERL5LIB}" \
    PATH="/app/local/bin:${PATH}"

# Copy application sources, templates, and deployment assets
COPY fogshared /app/
COPY bin/ /app/bin/
COPY lib/ /app/lib/
COPY templates/ /app/templates/
COPY public/ /app/public/
COPY config/ /app/config/
COPY deploy/ /app/deploy/

# Restrict write permissions strictly to the persistent data volume
RUN chmod +x /app/deploy/docker/entrypoint.sh /app/fogshared /app/bin/* \
    && mkdir -p /app/data \
    && chown -R nginx:nginx /app/data

# Persistent storage volume
VOLUME ["/app/data"]

EXPOSE 3642

ENV MOJO_MODE=production \
    APP_CONFIG=/app/data/fogshare.json \
    APP_PASSWD_FILE=/app/data/passwd.json \
    APP_DATA_DIR=/app/data

ENTRYPOINT ["/app/deploy/docker/entrypoint.sh"]