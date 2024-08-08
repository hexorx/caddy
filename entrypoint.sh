#!/bin/sh

# Start Tailscale
/app/tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &
/app/tailscale up --authkey=${TS_AUTH_KEY} --hostname=caddy-site --ssh
echo Tailscale started
ALL_PROXY=socks5://localhost:1055/

# Start Caddy
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
