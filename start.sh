#! /usr/bin/env sh

set -e

if [ -n "${domain}" ] ; then
    domains="$domain"
fi

if [ -z "${domains}" ] ; then
    domains="_" #localhost ? the ip??
    echo "Didn't find any domains, won't add them to nginx configuration"
else
    wwwdomains=""
    for domain in $domains; do
        wwwdomains="${wwwdomains} www.${domain}"
    done
    echo "$wwwdomains"
fi

#set tls if available
if [ -n "$use_tls" ] && [ "$use_tls" = "true" ] ; then
    echo "Using tls"
    template_str=$(cat "nginx_ssl_template.conf")
else
    echo "Not using tls"
    template_str=$(cat "nginx_template.conf")
fi

#set the nginx confog
eval "echo \"${template_str}\"" > /etc/nginx/conf.d/nginx.conf

#set gunicorn conf if available
if [ -n "$gunicorn_config_file" ] ; then
    cat /default_gunicorn_config_file.py "$gunicorn_config_file" > /gunicorn.conf.py
else
    cat /default_gunicorn_config_file.py > gunicorn.conf.py
fi

exec supervisord -c /supervisord.conf
