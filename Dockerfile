# Extracting logic from `civi-download-tools`
# https://github.com/civicrm/civicrm-buildkit/blob/7641b2ae6109225b24fb7e25f68d57a8f8493e29/bin/civi-download-tools
# PLATFORM=linux-amd64
# FORMAT=tgz
# https://github.com/github/hub/releases/download/v${VERSION}/hub-linux-amd64-${VERSION}.tgz

# Pull base image.
FROM ubuntu:14.04

RUN apt-get update

# Install curl
RUN apt-get install -y curl

# Install.
# this includes:
# git clone "https://github.com/civicrm/civicrm-buildkit.git" "$PRJDIR"
RUN curl -Ls https://civicrm.org/get-buildkit.sh | bash -s -- --full --dir ~/buildkit

# on precise so lines 310-313
# was RUN curl -sL https://deb.nodesource.com/setup_0.12 | bash
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash
RUN apt-get -y install \
  acl \
  git \
  wget \
  unzip \
  zip \
  mysql-server \
  mysql-client \
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
  nodejs

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
RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/2091762d2ebef14c02301f3039c41d08468fb49e/web/installer -O - -q | php -- --quiet
RUN mv composer.phar buildkit/bin/composer
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
RUN npm install


RUN a2enmod rewrite
RUN apache2ctl restart
# fixme apache2: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message



# Define default command.
CMD ["bash"]
