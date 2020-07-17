#!/bin/bash

version="latest"

if [ "x$1" != "x" ]; then
  version="${1}"
fi

image_name="appdynamicscx/configmyapp"

if [ "x$2" != "x" ]; then
  image_name="${2}"
fi

file="docker/Dockerfile"
if [ "x$3" != "x" ]; then
  file="${3}"
fi

#change dir to the root folder
cd ../ && pwd
docker build --build-arg version=${version} -t ${image_name}:${version} --no-cache -f ${file}  .