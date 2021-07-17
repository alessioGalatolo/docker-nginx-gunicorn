#!/bin/bash

for IMAGE_FILE in $( ls *.Dockerfile ) ; do
    IFS="."
    IMAGE=( $IMAGE_FILE )
    IMAGE=${IMAGE[0]}.${IMAGE[1]}
    echo "Pushing galatolo/gunicorn-nginx:${IMAGE}"
    docker push "galatolo/gunicorn-nginx:${IMAGE}"
done

# set latest
echo "Pushing galatolo/gunicorn-nginx:latest"
docker push "galatolo/gunicorn-nginx:latest"
