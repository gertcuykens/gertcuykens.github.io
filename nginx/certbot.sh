#!/bin/zsh
set -eEuxo pipefail

uvx --with=certbot-nginx certbot certonly -n --agree-tos -m gert.cuykens@... --webroot -w /var/lib/letsencrypt --cert-name default -d ...,...
nginx -t
nginx -s reload

# https://eff-certbot.readthedocs.io/en/stable/using.html
# https://www.nginx.com/blog/using-free-ssltls-certificates-from-lets-encrypt-with-nginx/

# certbot certificates
# certbot renew --dry-run
# certbot delete --cert-name default

# certbot --cert-name default -d ...
# certbot -v --debug-challenges
# certbot --expand
# certbot --nginx -d ...

# cp /etc/letsencrypt/live/default/fullchain.pem /etc/clickhouse-server/server.crt
# cp /etc/letsencrypt/live/default/privkey.pem /etc/clickhouse-server/server.key
# chown clickhouse:clickhouse /etc/clickhouse-server/server.crt
# chown clickhouse:clickhouse /etc/clickhouse-server/server.key

