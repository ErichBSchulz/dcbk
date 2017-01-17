#!/bin/bash

echo "Clean up old containers"
docker rm -f buildkit

echo "rebuild the image"
docker build -t dcbk:v1 .

echo "make a container based on the image"
docker create \
  -p 2222:22 \
  -p 8001:8001 \
  -p 7979:7979 \
  --name buildkit dcbk:v1

echo "starting the container"
docker start buildkit

echo "you can open a bash shell with this command:"
echo "    docker exec -it buildkit bash"
