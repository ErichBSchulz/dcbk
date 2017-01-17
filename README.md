# Dockerised CiviCRM Buildkit (dcbk)

This is an attempt to make a vanilla docker container for the
[CiviCRM Buildkit](https://github.com/civicrm/civicrm-buildkit)
based on the buildkit
[full stack ubuntu instructions](https://github.com/civicrm/civicrm-buildkit/blob/master/doc/download-ubuntu.md)
with inspiration from
[progressivetech's efforts](https://github.com/progressivetech/docker-civicrm-buildkit).

The `Dockerfile` extracts the logic from `civi-download-tools`
([this version](https://github.com/civicrm/civicrm-buildkit/blob/7641b2ae6109225b24fb7e25f68d57a8f8493e29/bin/civi-download-tools)),
including the `npm` and `composer` phases and pulling the indidividual tools.

The standard docker flow is to:

* `build` an image (takes a long time with plenty of downloads)
* `create` a container based on this image
* `start` the container
* `exec` commands in the running container

The "clean-up and rebuild" steps are in the `rebuild.sh` script.

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

This should be how you start your container:

    docker start buildkit

You  can see the started container now with this command in a seperate session:

    docker ps


chmod -R 777 /var/lib/amp
groupadd www
usermod -g www ampuser
usermod -g www www-data
chown -R ampuser:www /var/lib/amp
id ampuser
id www-data


+++ amp create -f --root=/opt/buildkit/build/dmaster --name=cms --prefix=CMS_ --url=http://dmaster.localhost --output-file=/tmp/ampvarx66JQs --perm=admin
Register host "dmaster.localhost" (127.0.0.1) in "/etc/hosts" via helper "/tmp/fix-hosts-php-P5gRuh".
[sudo] password for ampuser:
Sorry, try again.
[sudo] password for ampuser:
Sorry, try again.
[sudo] password for ampuser:
Sorry, try again.
sudo: 3 incorrect password attempts
PHP Fatal error:  Uncaught exception 'RuntimeException' with message 'Failed to update hosts file (/etc/hosts) with (127.0.0.1 dmaster.localhost) [/tmp/fix-hosts-php-P5gRuh]' in phar:///opt/buildkit/bin/amp/src/Amp/Hostname/HostsFile.php:65
Stack trace:
#0 phar:///opt/buildkit/bin/amp/src/Amp/InstanceRepository.php(59): Amp\Hostname\HostsFile->createHostname('dmaster.localho...')
#1 phar:///opt/buildkit/bin/amp/src/Amp/Command/CreateCommand.php(78): Amp\InstanceRepository->create(Object(Amp\Instance), true, true, 'admin')
#2 phar:///opt/buildkit/bin/amp/vendor/symfony/console/Symfony/Component/Console/Command/Command.php(252): Amp\Command\CreateCommand->execute(Object(Symfony\Component\Console\Input\ArgvInput), Object(Symfony\Component\Console\Output\ConsoleOutput))
#3 phar:///opt/buildkit/bin/amp/vendor/symfony/console/Symfony/Component/Console/Application.php(889): Symfony\Component\Console\Command\Command->run(Object(Symfony\Component\Console\Input\ArgvInput), Object(Symfony\Component\Console\Output\ConsoleOutput))
#4 phar: in phar:///opt/buildkit/bin/amp/src/Amp/Hostname/HostsFile.php on line 65

Fatal error: Uncaught exception 'RuntimeException' with message 'Failed to update hosts file (/etc/hosts) with (127.0.0.1 dmaster.localhost) [/tmp/fix-hosts-php-P5gRuh]' in phar:///opt/buildkit/bin/amp/src/Amp/Hostname/HostsFile.php:65
Stack trace:
#0 phar:///opt/buildkit/bin/amp/src/Amp/InstanceRepository.php(59): Amp\Hostname\HostsFile->createHostname('dmaster.localho...')
#1 phar:///opt/buildkit/bin/amp/src/Amp/Command/CreateCommand.php(78): Amp\InstanceRepository->create(Object(Amp\Instance), true, true, 'admin')
#2 phar:///opt/buildkit/bin/amp/vendor/symfony/console/Symfony/Component/Console/Command/Command.php(252): Amp\Command\CreateCommand->execute(Object(Symfony\Component\Console\Input\ArgvInput), Object(Symfony\Component\Console\Output\ConsoleOutput))
#3 phar:///opt/buildkit/bin/amp/vendor/symfony/console/Symfony/Component/Console/Application.php(889): Symfony\Component\Console\Command\Command->run(Object(Symfony\Component\Console\Input\ArgvInput), Object(Symfony\Component\Console\Output\ConsoleOutput))
#4 phar: in phar:///opt/buildkit/bin/amp/src/Amp/Hostname/HostsFile.php on line 65
am
