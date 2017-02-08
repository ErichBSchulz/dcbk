# Extracting logic from `civi-download-tools`
# https://github.com/civicrm/civicrm-buildkit/blob/7641b2ae6109225b24fb7e25f68d57a8f8493e29/bin/civi-download-tools

################################################################################
## System downloads: General apt-get goodness

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

RUN php5enmod mcrypt && php5enmod imap && a2enmod rewrite && apache2ctl restart

################################################################################
# System downloads: Install NodeJS
# the previous pattern has been to install npm and npm-legacy but that broke
# on the `npm install` phase
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash \
  && apt-get install -y nodejs

################################################################################
## Buildkit downloads: Get civicrm-buildkit.git

RUN git clone "https://github.com/civicrm/civicrm-buildkit.git" /opt/buildkit

# Set environment variables.
ENV HOME /root
# Add build kit to the standard path
ENV PATH /opt/buildkit/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# Define working directory.
WORKDIR /root

RUN civi-download-tools

################################################################################
## System config: Handle service starting with runit.
# from https://github.com/progressivetech/docker-civicrm-buildkit/blob/master/Dockerfile#L52
RUN mkdir /etc/sv/mysql /etc/sv/apache /etc/sv/sshd
COPY mysql.run /etc/sv/mysql/run
COPY apache.run /etc/sv/apache/run
COPY sshd.run /etc/sv/sshd/run
COPY sshd.run /etc/sv/sshd/run
COPY runit_bootstrap /usr/sbin/runit_bootstrap
RUN update-service --add /etc/sv/mysql \
  && update-service --add /etc/sv/apache \
  && update-service --add /etc/sv/sshd \
  && chmod 755 /usr/sbin/runit_bootstrap
################################################################################
## System config: AMP
ENV AMPHOME /var/lib/amp
WORKDIR /root

RUN mkdir "$AMPHOME" "$AMPHOME/apache.d" "$AMPHOME/log" "$AMPHOME/my.cnf.d" "$AMPHOME/nginx.d" \
  && echo "IncludeOptional $AMPHOME/apache.d/*.conf" >> /etc/apache2/apache2.conf \
  && echo "ServerName civicrm-buildkit" > /etc/apache2/conf-available/civicrm-buildkit.conf

COPY services.yml $AMPHOME/services.yml

# fixme: what does this do??
RUN a2enconf civicrm-buildkit
RUN apache2ctl restart

################################################################################
# user set up (path and mysql):
# fixme - this is all scary and wrong - must be better way!
RUN useradd -m ampuser \
  && groupadd www \
  && echo 'declare -x PATH="/opt/buildkit/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' \
    >> /home/ampuser/.bashrc \
  && cp .my.cnf /home/ampuser \
  && chown ampuser /home/ampuser/.my.cnf \
  && chown -R ampuser:www /var/lib/amp \
  && echo "ampuser ALL=NOPASSWD: /usr/sbin/apachectl" >> /etc/sudoers.d/civicrm-buildkit \
  && chmod -R 777 /opt/buildkit \
  && chmod 666 /etc/hosts

#&& chmod 777 /var/lib/amp \
#  && chmod 777 /var/lib/amp/apache.d/ \

################################################################################

# Drupal requires mod rewrite.
# RUN a2enmod rewrite

################################################################################

################################################################################
# bootstrap
ENTRYPOINT ["/usr/sbin/runit_bootstrap"]


