#!/bin/bash

for IMAGE_FILE in $( ls *.Dockerfile ) ; do
    IFS="."
    IMAGE=( $IMAGE_FILE )
    IMAGE=${IMAGE[0]}.${IMAGE[1]}
    echo "Building galatolo/gunicorn-nginx:${IMAGE}"
    docker build -t "galatolo/gunicorn-nginx:${IMAGE}" . -f "${IMAGE_FILE}"
done

# set latest
echo "Building galatolo/gunicorn-nginx:latest"
docker build -t "galatolo/gunicorn-nginx:latest" . -f "${IMAGE_FILE}"
