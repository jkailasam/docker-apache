#!/bin/bash
SUBJECT="/C=US/ST=CA/L=Fremont/O=jeeva.us/OU=Personal/CN=*"
if [[ -f /config/keys/cert.key && -f /config/keys/cert.crt ]]; then
echo "using keys found in /config/keys"
else
echo "generating self-signed keys in /config/keys, you can replace these with your own keys if required"
openssl req -new -x509 -days 3650 -nodes -out /config/keys/cert.crt -keyout /config/keys/cert.key -subj "$SUBJECT"
fi