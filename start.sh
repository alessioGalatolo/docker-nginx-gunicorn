#! /usr/bin/env sh

set -e

if [ -n "${DOMAIN}" ] ; then
    DOMAINS="$DOMAIN"
fi

if [ -z "${DOMAINS}" ] ; then
    DOMAINS="_"
    echo "Didn't find any domains, won't add them to nginx configuration"
else
    echo "Found these domains: ${DOMAINS}"
    WWW_DOMAINS=""
    for domain in $DOMAINS; do
        WWW_DOMAINS="${WWW_DOMAINS} www.${domain}"
    done
fi

#set tls if available
if [ -n "$USE_TLS" ] && [ "$USE_TLS" = "true" ] ; then
    echo "Using tls"
    NGINX_TEMPLATE=$(cat "nginx_ssl_template.conf")
else
    echo "Not using tls"
    NGINX_TEMPLATE=$(cat "nginx_template.conf")
fi

#set the nginx confog
eval "echo \"${NGINX_TEMPLATE}\"" > /etc/nginx/conf.d/nginx.conf

#set gunicorn conf if available
if [ -n "$GUNICORN_CONFIG_FILE" ] ; then
    cat /default_gunicorn_config_file.py "$GUNICORN_CONFIG_FILE" > /gunicorn.conf.py
else
    cat /default_gunicorn_config_file.py > gunicorn.conf.py
fi

exec supervisord -c /supervisord.conf
