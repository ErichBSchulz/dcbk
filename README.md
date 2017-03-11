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

The "clean-up and rebuild" steps are in the `rebuild.sh` script. The `rebuild.sh` script also provides details on using you container via the CLI once you have built it.

## Set up your hosts file for browsing

In order to use your browser you will need to add entries to your computers `/etc/hosts` file.

Find out the IP address of your container with:

    docker inspect buildkit | grep IPAddress

For example, if your "`CMS_URL`" is `http://dmaster.localhost` and
your containers IP address is `172.17.0.2` add this to `/etc/hosts`:

    172.17.0.2 dmaster.localhost

## SSH and your docker

I am currently using docker to open a CLI shell, but
you may wish to `ssh` into your docker. While apparently this is not standard practice, if do want to then this is how (I think):

First generate a key with `ssh-keygen`. Call your key `id_rsa_bk`. After generating your key if you look in your ~/.ssh directory with `ls -lat ~/.ssh/*_bk*` you should see these two files with these permsission settings:

```
-rw------- 1 [you] [you] 1675 Jan 21 14:15 /home/[you]/.ssh/id_rsa_bk
-rw-r--r-- 1 [you] [you]  392 Jan 21 14:15 /home/[you]/.ssh/id_rsa_bk.pub
```

Second, copy your public key into this directory:

    cp ~/.ssh/id_rsa_bk.pub .

Third, add these lines to your `~/.ssh/config` file:

    Host bk
    HostName localhost
    Port 2222
    User ampuser
    IdentityFile ~/.ssh/id_rsa_bk

You may then `ssh` into your container with

    ssh bk

And you can use `rcp` to copy files around (should you need to)

    rcp -r bk:/opt/buildkit .


