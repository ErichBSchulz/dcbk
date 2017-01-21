#!/bin/bash

# This script is merely a little sugar to automate the build, start
# and test cycle.

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

echo "build complete!"
echo "You can open a bash shell with this command:"
echo "    docker exec -it buildkit bash"
echo "Once you have opened a shell into your container, you can build your first CiviCRM with something like this:"
echo "    su ampuser"
echo "    cd"
echo "    civibuild create dmaster --url http://dmaster.localhost --admin-pass s3cr3t"

