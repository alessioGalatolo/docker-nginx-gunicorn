#!/bin/bash
BUILD_DATE=$(date +'%d-%m-%Y')

for IMAGE_FILE in $( ls *.Dockerfile ) ; do
    IFS="."
    IMAGE=( $IMAGE_FILE )
    IMAGE=${IMAGE[0]}.${IMAGE[1]}
    echo "Building galatolo/gunicorn-nginx:${IMAGE}"
    docker build -t "galatolo/gunicorn-nginx:${IMAGE}" -t "galatolo/gunicorn-nginx:${IMAGE}-${BUILD_DATE}" . -f "${IMAGE_FILE}"
    echo "Pushing galatolo/gunicorn-nginx:${IMAGE}"
    docker push "galatolo/gunicorn-nginx:${IMAGE}"
    docker push "galatolo/gunicorn-nginx:${IMAGE}-${BUILD_DATE}"
done

# set latest
echo "Building galatolo/gunicorn-nginx:latest"
docker build -t "galatolo/gunicorn-nginx:latest" . -f "${IMAGE_FILE}"
echo "Pushing galatolo/gunicorn-nginx:latest"
docker push "galatolo/gunicorn-nginx:latest"
