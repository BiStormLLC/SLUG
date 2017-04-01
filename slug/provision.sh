#!/usr/bin/env bin/sh

mkdir -p /slug

export PHP_V="7.0"

# Timezone
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Useful ibraries
apk upgrade --update && apk add --no-cache \
    autoconf \
    gcc \
    g++ \
    make \
    autoconf \
    pcre \
    perl \
    openssh \
    git \
    nano \
    grep \
    pcre \
    bash \
    vim \
    curl \
    zip \
    unzip \
    python \
    linux-headers \
    binutils-gold \
    gnupg \
    libstdc++

#PHP 
apk add php-cli
docker-php-source extract 
pecl install xdebug 
docker-php-ext-install \
    json \
    curl \
    gd \
    gmp \
    imap \
    mcrypt \
    soap \
    mbstring \
    zip

docker-php-ext-enable \
    xdebug json curl gd gmp imap mcrypt soap mbstring zip

docker-php-source delete \

# User/Group management for PHP
mkdir -p /run/php
touch /run/php/php7.0-fpm.sock

# Set Some PHP CLI Settings
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/$PHP_V/cli/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/$PHP_V/cli/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/$PHP_V/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/$PHP_V/cli/php.ini

sed -i "s/.*daemonize.*/daemonize = no/" /etc/php/$PHP_V/fpm/php-fpm.conf
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/$PHP_V/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/$PHP_V/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/$PHP_V/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/$PHP_V/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/$PHP_V/fpm/php.ini

# Enable Remote xdebug
echo "xdebug.default_enable=0" >> /usr/local/etc/php/conf.d/xdebug.ini 
echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/xdebug.ini 
echo "xdebug.profiler_enable=0" >> /usr/local/etc/php/conf.d/xdebug.ini 
echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini 
echo "xdebug.remote_autostart=0" >> /usr/local/etc/php/conf.d/xdebug.ini 
echo "xdebug.remote_host=9011" >> /usr/local/etc/php/conf.d/xdebug.ini 
echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/xdebug.ini 
echo "xdebug.idekey=deslug" >> /usr/local/etc/php/conf.d/xdebug.ini 






