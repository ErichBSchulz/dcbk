#!/bin/bash

# This script is merely a little sugar to automate the build, start
# and test cycle.

echo "Rebuilding the image"
docker build -t dcbk:v1 .

echo "Cleaning up old containers"
docker rm -f buildkit
echo "Making folders for the mounted volumes"
mkdir -p ampuser build
echo "Making a container based on the image"
docker create  -p 2222:2222  -p 8001:8001  -p 8000:80  -v $(pwd)/ampuser:/home/ampuser -v $(pwd)/build:/opt/buildkit/build --name buildkit dcbk:v1
echo "starting the container"
docker start buildkit

echo "build complete!"
echo "
You can open a bash shell with this command:

    docker exec -it buildkit bash

Once you have opened a shell into your container, you can build your first CiviCRM with something like this (the \`sudo chown\` steps are hacky and may or may not be needed):

    su ampuser
    sudo cp /root/.my.cnf ~
    sudo chown ampuser ~/.my.cnf
    cd
    BUILDROOT=/opt/buildkit/build/dmaster
    sudo chown -R --quiet ampuser:www-data \$BUILDROOT
    civibuild create dmaster --url http://dmaster.localhost --admin-pass s3cr3t
    sudo chown -R --quiet www-data:www-data \$BUILDROOT

To run unit tests (as root currently)

    cd \$BUILDROOT/sites/all/modules/civicrm/tools
    sudo chown ampuser:ampuser \$BUILDROOT/sites/default/files/civicrm -R
    sudo chmod 777 \$BUILDROOT/sites/default/files/civicrm -R
    ./scripts/phpunit api_v3_ContactTest

To tail the logs use:

    docker logs -f buildkit

or

    tail \$BUILDROOT/sites/default/files/civicrm/ConfigAndLog/CiviCRM.*.log -f
"

