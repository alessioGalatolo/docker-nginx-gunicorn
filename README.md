# Docker-nginx-gunicorn
This is a docker image to run a server with gunicorn + nginx with support for ssl connections.

# Use
todo
```
    docker build -t myserver
    docker run -p 80:80 443:443 myserver -e domains="mydomain.com" use_tls="true"
```
# Todo:
Add automatic certificate generation through certbot
