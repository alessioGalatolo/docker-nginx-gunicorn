# Docker-nginx-gunicorn
This is a docker image to run a Python web application in a server with gunicorn + nginx + support for tls connections.
This will also support automatic certificate retrival through letsencrypt

# How to use
You can use this image by just including in your Dockerfile:
```Dockerfile
FROM galatolo/nginx-gunicorn:latest

# The rest of the Dockerfile
```
Then you can run the build and run the container as follows:
```sh
docker build -t myserver
docker run -p 80:80 443:443 myserver
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
## Use custom gunicorn configuration
You can change the gunicorn configuration by adding your [configuration file](https://docs.gunicorn.org/en/latest/configure.html#configuration-file) to the container and by defining the environment variable `GUNICORN_CONFIG_FILE` to point to your file:
```Dockerfile
COPY ./myconfiguration.py /myconfiguration.py

ENV GUNICORN_CONFIG_FILE="/myconfiguration.py"
```
Your configuration will override the deafult ones.
**Note:** Changing the settings for `host`, `port` or `bind` will BREAK the image.
# Todo:
Add automatic certificate generation through certbot
Better documentation
More tag options
