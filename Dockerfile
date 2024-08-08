FROM caddy:alpine

COPY ./site/ /srv/
COPY ./Caddyfile /etc/caddy/Caddyfile

# Install dependencies for Tailscale
RUN apk add --no-cache iptables=1.8.7-r1 ip6tables=1.8.7-r1 curl=7.78.0-r0

# Install Tailscale
RUN curl -fsSL https://pkgs.tailscale.com/stable/alpine/tailscale_1.50.0_amd64.tgz | tar xz -C /usr/local/bin

# Expose necessary ports
EXPOSE 80 443 22

# Set the command to run Tailscale and Caddy
CMD tailscaled & \
  tailscale up --authkey=${TS_AUTH_KEY} --ssh && \
  caddy run --config /etc/caddy/Caddyfile --adapter caddyfile

