# Dockerised CiviCRM Buildkit (dcbk)

This is an attempt to make a vanilla docker container for the
[CiviCRM Buildkit](https://github.com/civicrm/civicrm-buildkit)
based on the buildkit
[full stack ubuntu instructions](https://github.com/civicrm/civicrm-buildkit/blob/master/doc/download-ubuntu.md)
with inspiration from
[progressivetech's efforts](https://github.com/progressivetech/docker-civicrm-buildkit).

The standard docker flow is to:

* `build` an image (takes a long time with plenty of downloads)
* `create` a container based on this image
* `start` the container

## Build

      # build the image with name dcbk:v1
      docker build -t dcbk:v1 .

See your images with `docker images`.


## Create

This is the progressivetech example with shared volumes, environment variables and :

    docker create -v "$(pwd)/civicrm:/var/www/civicrm" -e "DOCKER_UID=$UID" \
      -p 2222:22 -p 8001:8001 --name civicrm-buildkit civicrm-buildkit

But I'm just trying this for now:

    docker create -p 2222:22 -p 8001:8001 --name buildkit dcbk:v1



## Start

So, AFAIK this should be how you start your container:

    docker start buildkit

But my dockerfile must be wrong, so instead I can start it by using `docker run`:

    docker run -it dcbk:v1 /bin/bash

I can see the started container now with this command in a seperate session:

    docker ps --all --size



