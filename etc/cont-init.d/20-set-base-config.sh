#!/bin/bash
mkdir -p /config/apache/site-confs /config/www /config/log/apache /config/keys

if [ ! -f "/config/apache/site-confs/default.conf" ]; then
cp /defaults/default.conf /config/apache/site-confs/default.conf
fi

if [[ $(find /config/www -type f | wc -l) -eq 0 ]]; then
cp /defaults/index.html /config/www/index.html
fi

chown -R abc:abc /config
chown -R abc:abc /var/lib/apache2/fastcgi