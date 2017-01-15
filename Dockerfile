# Extracting logic from `civi-download-tools`
# https://github.com/civicrm/civicrm-buildkit/blob/7641b2ae6109225b24fb7e25f68d57a8f8493e29/bin/civi-download-tools

# Pull base image.
FROM ubuntu:14.04

RUN apt-get update && apt-get install -y \
  acl \
  git \
  curl \
  wget \
  unzip \
  zip \
  mysql-server-5.5 \
  mysql-client-5.5 \
  php5-cli \
  php5-imap \
  php5-ldap \
  php5-curl \
  php5-mysql \
  php5-intl \
  php5-gd \
  php5-mcrypt \
  php-apc \
  apache2 \
  libapache2-mod-php5 \
  makepasswd \
  && rm -rf /var/lib/apt/lists/*

# install node
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash

## Fixme are these basic helpers useful?
## (from here)[https://github.com/civicrm/civicrm-buildkit/blob/master/vagrant/trusty32-standalone/bootstrap.sh]
##    colordiff \ git-man \ joe \ makepasswd \ patch \ rsync \ subversion \

RUN git clone "https://github.com/civicrm/civicrm-buildkit.git" /root/buildkit

# Set environment variables.
ENV HOME /root
# Add build kit to the standard path
ENV PATH /root/buildkit/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Define working directory.
WORKDIR /root

# install composer
#
# Approach lifted from:
# https://getcomposer.org/doc/faqs/how-to-install-composer-programmatically.md
# To update replace the commit hash by whatever the last commit hash is on
# https://github.com/composer/getcomposer.org/commits/master
RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/2091762d2ebef14c02301f3039c41d08468fb49e/web/installer -O - -q | php -- --quiet \
  &&  mv composer.phar buildkit/bin/composer
# fixme warning: Do not run Composer as root/super user! See https://getcomposer.org/root for details

# Warnings:
# symfony/console suggests installing psr/log (For using the console logger)
# symfony/console suggests installing symfony/event-dispatcher ()
# phpunit/php-code-coverage suggests installing ext-xdebug (>=2.0.5)
# phpunit/phpunit suggests installing phpunit/php-invoker (>=1.1.0,<1.2.0)
# pear/console_table suggests installing pear/Console_Color (>=0.0.4)
# symfony/dependency-injection suggests installing symfony/proxy-manager-bridge (Generate service proxies to lazy load them)
# symfony/templating suggests installing psr/log (For using debug logging in loaders)


## Download dependencies (via composer)
WORKDIR /root/buildkit
RUN composer install

## Download dependencies (via npm)
RUN apt-get install -y nodejs \
  && npm install

## Download dependencies (directly)
RUN curl -L -o bin/drush8 http://files.drush.org/drush.phar
RUN chmod +x bin/drush8
RUN curl -L -o bin/cv https://download.civicrm.org/cv/cv.phar-2017-01-10-f6b47864
RUN chmod +x bin/cv
RUN curl -L -o bin/phpunit4 https://phar.phpunit.de/phpunit-4.8.21.pharL
RUN chmod +x bin/phpunit4
RUN curl -L -o bin/wp https://github.com/wp-cli/wp-cli/releases/download/v0.24.1/wp-cli-0.24.1.phar
RUN chmod +x bin/wp
RUN curl -L -o bin/git-scan https://download.civicrm.org/git-scan/git-scan.phar-2017-01-02-afcec5d4
RUN chmod +x bin/git-scan
RUN curl -L -o bin/amp https://download.civicrm.org/amp/amp.phar-2016-10-12-41c6b749
RUN chmod +x bin/amp
RUN curl -L -o bin/civix https://download.civicrm.org/civix/civix.phar-2017-01-02-dd122605
RUN chmod +x bin/civix
RUN curl -L -o bin/civistrings https://download.civicrm.org/civistrings/civistrings.phar-2016-03-10-df547ff9
RUN chmod +x bin/civistrings
RUN curl -L -o bin/joomla https://download.civicrm.org/joomlatools-console/joomla.phar-2016-07-15-d2b7d23a
RUN chmod +x bin/joomla

# Get the hub
# NB - HUB_VERSION="2.2.9" (nb was 2.2.3).
RUN curl -L -o hub.tgz https://github.com/github/hub/releases/download/v2.2.9/hub-linux-amd64-2.2.9.tgz
RUN mkdir -p extern/hub
RUN tar --strip-components=1 -xvzf hub.tgz
RUN rm hub.tgz

# set user
RUN MYSQLPASS=$(makepasswd --chars=16) \
  && echo "mysql-server-5.5 mysql-server/root_password password $MYSQLPASS" | debconf-set-selections \
  && echo "mysql-server-5.5 mysql-server/root_password_again password $MYSQLPASS" | debconf-set-selections \
  && printf "[client]\nuser=root\npassword=$MYSQLPASS" > /root/.my.cnf \
  && chmod 600 /root/.my.cnf

## AMP configuration

WORKDIR /root
RUN mkdir .amp .amp/apache.d .amp/log  .amp/my.cnf.d  .amp/nginx.d \
  && echo "Include /root/.amp/apache.d/*.conf" >> /etc/apache2/apache2.conf

COPY services.yml /root/.amp
RUN a2enmod rewrite
RUN apache2ctl restart
# fixme apache2: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message


