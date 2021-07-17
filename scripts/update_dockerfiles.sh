#!/bin/bash

# Running this script will generate the Dockerfiles with the appropriate tag
SUPPORTED_TAGS="python:3.6-alpine python:3.7-alpine python:3.8-alpine python:3.9-alpine"

for TAG in $SUPPORTED_TAGS ; do
    echo "Building dockerfile for tag ${TAG}"
    FROM_LINE="FROM ${TAG}"
    IFS=':'
    FILENAME=( $TAG )
    FILENAME=${FILENAME[0]}${FILENAME[1]}
    echo "${FROM_LINE}" | cat - "./Dockerfile.template" > "./${FILENAME}.Dockerfile"
done
