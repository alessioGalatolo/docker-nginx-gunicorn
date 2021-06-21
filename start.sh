#! /usr/bin/env sh

set -e

if [ -n '${domain}'] ; then
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

if [ -n "$use_tls" ] && [ "$use_tls" = "true" ] ; then
    echo "Using tls"
    template_str=$(cat "nginx_ssl_template.conf")
else
    echo "Not using tls"
    template_str=$(cat "nginx_template.conf")
fi

eval "echo \"${template_str}\"" > /etc/nginx/conf.d/nginx.conf
exec supervisord -c /supervisord.conf
