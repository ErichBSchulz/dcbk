#!/bin/bash

echo "Rebuilding the image"
docker build -t dcbk:v1 .

echo "Cleaning up old containers"
docker rm -f buildkit
echo "Making a container based on the image"
docker create \
  -p 2222:22 \
  -p 8001:8001 \
  -p 80:8002 \
  --name buildkit dcbk:v1
echo "starting the container"
docker start buildkit

echo "You can open a bash shell with this command:"
echo "    docker exec -it buildkit bash"

