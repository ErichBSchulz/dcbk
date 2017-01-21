# Dockerised CiviCRM Buildkit (dcbk)

This currently a simple vanilla docker container for the
[CiviCRM Buildkit](https://github.com/civicrm/civicrm-buildkit)
based on the buildkit
[full stack ubuntu instructions](https://github.com/civicrm/civicrm-buildkit/blob/master/doc/download-ubuntu.md)
with inspiration from
[progressivetech's efforts](https://github.com/progressivetech/docker-civicrm-buildkit).

The `Dockerfile` extracts the logic from `civi-download-tools`
([this version](https://github.com/civicrm/civicrm-buildkit/blob/7641b2ae6109225b24fb7e25f68d57a8f8493e29/bin/civi-download-tools)).

The standard docker flow is to:

* `build` an image (takes a long time with plenty of downloads)
* `create` a container based on this image
* `start` the container
* `exec` commands in the running container

The "clean-up and rebuild" steps are in the `rebuild.sh` script.

In order to use your browser you will need to add entries to your computers `/etc/hosts` file.

Find out the IP address of your container with:

    docker inspect buildkit | grep IPAddress

For example, if your "`CMS_URL`" is `http://dmaster.localhost` and
your containers IP address is `172.17.0.2` add this to `/etc/hosts`:

    172.17.0.2 dmaster.localhost

