#!/bin/sh

docker build -t galatolo/gunicorn-nginx:latest ..
docker push galatolo/gunicorn-nginx:latest
