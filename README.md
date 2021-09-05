# Docker-nginx-gunicorn
This is a docker image to run a Python web application in a server with gunicorn + nginx + support for tls connections.
This will also support automatic certificate retrival through letsencrypt.

These are the available tags:
* [`python3.9-alpine`, `latest`](https://github.com/alessioGalatolo/docker-nginx-gunicorn/blob/master/python3.9-alpine.Dockerfile)
* [`python3.8-alpine`](https://github.com/alessioGalatolo/docker-nginx-gunicorn/blob/master/python3.8-alpine.Dockerfile)
* [`python3.7-alpine`](https://github.com/alessioGalatolo/docker-nginx-gunicorn/blob/master/python3.7-alpine.Dockerfile)
* [`python3.6-alpine`](https://github.com/alessioGalatolo/docker-nginx-gunicorn/blob/master/python3.6-alpine.Dockerfile)

**Note**: There are [tags for each build date](https://hub.docker.com/r/galatolo/gunicorn-nginx/tags). If you need to "pin" the Docker image version you use (strongly recommended), you can select one of those tags. E.g. `galatolo/gunicorn-nginx:python3.7-alpine-05-09-2021`.
# How to use
You can use this image by just including in your Dockerfile:
```Dockerfile
FROM galatolo/nginx-gunicorn:<tag> # Swap <tag> with one from the ones above

# The rest of the Dockerfile
```
Then you can run the build and run the container as follows:
```sh
docker build -t myserver .
docker run -p 80:80 myserver
```
You can define environmental variables in order to customize the behaviour of the image.
For example, if you want to use the application with your custom domain, you would add to your Dockerfile:
```Dockerfile
# Do not include www when writing your domain
ENV DOMAIN="mydomain.com"

# If you want to use more than one domain you can write them with a space in between
ENV DOMAINS="mydomain1.com mydomain2.com mydomain3.com"

# Add other ENVs here...
```
## Where to add your application
This image will look to execute by default the WSGI module variable called `app` inside the container path `/app/main.py` (see `/example_app` for an example of such file). To use the default configuration add your application to the container's `/app` folder:
```Dockerfile
COPY ./myapp /app
```
To customize the app location you can use the `MODULE_NAME`, `VARIABLE_NAME` environment variables:
```Dockerfile
COPY ./myapp /myapp

ENV VARIABLE_NAME="myvariable"
ENV MODULE_NAME="myapp"
ENV PYTHONPATH="/myapp"
```
**Note:** Do not forget to also change `PYTHONPATH` variable to point to your app location 
## How to add TLS to your server
**Note:** Right now automatic certificate generation is not supported yet. If you want to use TLS you must have the certificates already. 
```Dockerfile
COPY ./my_certificates/certificate.pem /.ssl/cert.pem
COPY ./my_certificates/certificate_private.pem /.ssl/private.pem

ENV USE_TLS="true"
ENV DOMAIN="mydomain.com"
```
Remember to also bind port 443 if you are using TLS when running the image:
```sh
docker run -p 80:80 -p 443:443 myserver
```
## Enable DDOS protection
This image comes with a very simple protection against DDOS attack based on a request limiter.
In order to enable it add the following to your docker file:
```Dockerfile
ENV DDOS_PROTECTION="true"
```
You can change the number of requests accepted every second as follows (default is 30 requests/s):
```Dockerfile
ENV REQUEST_LIMIT="50"
```
You might want to increase this number if users are getting frequent 503 errors.
## Use custom gunicorn configuration
You can change the gunicorn configuration by adding your [configuration file](https://docs.gunicorn.org/en/latest/configure.html#configuration-file) to the container and by defining the environment variable `GUNICORN_CONFIG_FILE` to point to your file:
```Dockerfile
COPY ./myconfiguration.py /myconfiguration.py

ENV GUNICORN_CONFIG_FILE="/myconfiguration.py"
```
Your configuration will override the deafult ones.
**Note:** Changing the settings for `host`, `port` or `bind` will BREAK the image.
## Use custom HTTP/S ports
In case you want to use different ports from the standard ones 80/443 you can use the following to specify your own:
```Dockerfile
ENV HTTP_PORT="81"
ENV HTTPS_PORT="444"
```
Do not forget to also bind those ports when running the image:
```sh
docker run -p 81:81 -p 444:444 myserver
```
# Todo:
Add automatic certificate generation through certbot

Better documentation

Implement debian tag options

Implement tests
