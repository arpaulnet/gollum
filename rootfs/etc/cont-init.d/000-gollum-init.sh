#!/usr/bin/with-contenv /bin/ash
# Set timezone
ln -sf "/usr/share/zoneinfo/${TZ}" /etc/localtime

# Create app group & user
addgroup -g "${PGID}" app
adduser -s /sbin/nologin -D -H -u "${PUID}" -G app app

# Create /wiki volume & set to default if missing
[ ! -d /wiki ] && mkdir /wiki

# Create .git in /wiki if missing
[ ! -d /wiki/.git ] && cp -r /default/wiki/.git /wiki

# Set permissions
chown -R app:app /wiki
