# Extracting logic from `civi-download-tools`
# https://github.com/civicrm/civicrm-buildkit/blob/7641b2ae6109225b24fb7e25f68d57a8f8493e29/bin/civi-download-tools

# Pull base image.
FROM ubuntu:14.04

# core dependancies:
RUN apt-get update && apt-get install -y \
  acl \
  git \
  curl \
  wget \
  unzip \
  zip \
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
  runit

# Set-up mysql password before installing mysql
# (this step depends on makepasswd, so splitting requires splitting the apt install)
# set mysql root user password:
RUN MYSQLPASS=$(makepasswd --chars=16) \
  && echo "mysql-server-5.5 mysql-server/root_password password $MYSQLPASS" | debconf-set-selections \
  && echo "mysql-server-5.5 mysql-server/root_password_again password $MYSQLPASS" | debconf-set-selections \
  && printf "[client]\nuser=root\npassword=$MYSQLPASS" > /root/.my.cnf \
  && chmod 600 /root/.my.cnf
# MySQL
RUN apt-get install -y \
  mysql-server-5.5 \
  mysql-client-5.5

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

################################################################################
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

################################################################################
# install node
# the previous pattern has been to install npm and npm-legacy but that broke
# on the `npm install` phase
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash \
  && apt-get install -y nodejs
## Download dependencies (via npm)
RUN npm install

################################################################################
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

################################################################################
# Get the hub
# NB - HUB_VERSION="2.2.9" (nb was 2.2.3).
RUN curl -L -o hub.tgz https://github.com/github/hub/releases/download/v2.2.9/hub-linux-amd64-2.2.9.tgz
RUN mkdir -p extern/hub
RUN tar --strip-components=1 -xvzf hub.tgz
RUN rm hub.tgz

################################################################################
# Handle service starting with runit.
# from https://github.com/progressivetech/docker-civicrm-buildkit/blob/master/Dockerfile#L52
RUN mkdir /etc/sv/mysql /etc/sv/apache /etc/sv/sshd
COPY mysql.run /etc/sv/mysql/run
COPY apache.run /etc/sv/apache/run
COPY sshd.run /etc/sv/sshd/run
RUN update-service --add /etc/sv/mysql
RUN update-service --add /etc/sv/apache
RUN update-service --add /etc/sv/sshd

COPY sshd.run /etc/sv/sshd/run
################################################################################
## AMP configuration
WORKDIR /root
RUN mkdir .amp .amp/apache.d .amp/log  .amp/my.cnf.d  .amp/nginx.d \
  && echo "IncludeOptional /root/.amp/apache.d/*.conf" >> /etc/apache2/apache2.conf \
  && echo "ServerName civicrm-buildkit" > /etc/apache2/conf-available/civicrm-buildkit.conf

COPY services.yml /root/.amp

# Drupal requires mod rewrite.
# RUN a2enmod rewrite

RUN a2enconf civicrm-buildkit
RUN apache2ctl restart

COPY runit_bootstrap /usr/sbin/runit_bootstrap
RUN chmod 755 /usr/sbin/runit_bootstrap
ENTRYPOINT ["/usr/sbin/runit_bootstrap"]
