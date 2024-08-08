FROM caddy:2.8.4-builder AS builder

RUN xcaddy build \
  --with github.com/greenpau/caddy-security \
  --with github.com/caddy-dns/cloudflare

FROM caddy:2.8.4

# Copy Caddy binary from the builder stage.
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY Caddyfile /etc/caddy/Caddyfile

# Copy Tailscale binaries from the tailscale image on Docker Hub.
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /app/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /app/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

# Copy the entrypoint script.
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Copy site files.
COPY site /app/site

# Add port for 80, 443, 443 udp, and 22
EXPOSE 80 443 443/udp 22

CMD ["/app/entrypoint.sh"]

