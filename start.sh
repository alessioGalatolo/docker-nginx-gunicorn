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

#check if different http port has been set
if [ -z "${HTTP_PORT}" ] ; then
    HTTP_PORT="80"
fi

#check if different https port has been set
if [ -z "${HTTPS_PORT}" ] ; then
    HTTPS_PORT="443"
fi

#set ddos protection if enabled
if [ -n "${DDOS_PROTECTION}" ] && [ "$DDOS_PROTECTION" = "true" ] ; then
    echo "Using DDOS protection"
    #check if custom rate is given
    if [ -z "${REQUEST_LIMIT}" ] ; then
        REQUEST_LIMIT="30"
    fi
    DDOS_PROTECTION_COMMAND_1="limit_req_zone \$binary_remote_addr zone=one:10m rate=${REQUEST_LIMIT}r/s;"
    DDOS_PROTECTION_COMMAND_2="limit_req zone=one burst=${REQUEST_LIMIT};"
fi

#set tls if available
if [ -n "$USE_TLS" ] && [ "$USE_TLS" = "true" ] ; then
    echo "Using tls"
    NGINX_TEMPLATE=$(cat "nginx_ssl_template.conf")
else
    echo "Not using tls"
    NGINX_TEMPLATE=$(cat "nginx_template.conf")
fi

#set the nginx config
rm -f /etc/nginx/conf.d
eval "echo \"${NGINX_TEMPLATE}\"" > /etc/nginx/nginx.conf

#set gunicorn conf if available
if [ -n "$GUNICORN_CONFIG_FILE" ] ; then
    cat /default_gunicorn_config_file.py "$GUNICORN_CONFIG_FILE" > /gunicorn.conf.py
else
    cat /default_gunicorn_config_file.py > gunicorn.conf.py
fi

exec supervisord -c /supervisord.conf
