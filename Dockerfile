FROM drupal:8-apache

RUN apt-get update && \
  apt-get install -y gnupg && \
  (curl -sL https://deb.nodesource.com/setup_8.x | bash -) && \
  apt-get install -y git-core mysql-client nodejs \
    imagemagick libbz2-dev libc-client-dev libcurl4-openssl-dev libfreetype6-dev libgmp-dev libgpgme11-dev libjpeg62-turbo-dev libkrb5-dev libldap2-dev libldb-dev libmagickwand-dev libmcrypt-dev libmemcached-dev libpng-dev libpspell-dev libssh2-1-dev libtidy-dev libxml2-dev libxslt-dev libyaml-dev && \
  ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
  docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
  docker-php-ext-install bcmath calendar dba exif gd gettext gmp imap ldap mbstring pcntl pdo pdo_mysql pspell shmop soap sockets sysvmsg sysvsem sysvshm tidy wddx xmlrpc xsl && \
  (echo '' | pecl install apcu gnupg igbinary imagick mcrypt-1.0.1 memcached oauth propro raphf ssh2-alpha xdebug yaml) && \
  docker-php-ext-enable apcu gnupg igbinary imagick mcrypt memcached oauth propro raphf ssh2 xdebug yaml && \
  (echo '' | pecl install pecl_http) && \
  docker-php-ext-enable http && \
  ln -s /usr/sbin/composer.phar /usr/sbin/composer && \
  curl https://raw.githubusercontent.com/composer/getcomposer.org/d3e09029468023aa4e9dcd165e9b6f43df0a9999/web/installer | php -- --install-dir /usr/sbin --quiet

ENV COMPOSER_ALLOW_SUPERUSER 1
