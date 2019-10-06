FROM php:7.3-apache-stretch

ENV APACHE_DOCUMENT_ROOT /var/www/html

RUN echo "deb http://cdn.debian.net/debian/ stretch main contrib non-free" > /etc/apt/sources.list.d/mirror.jp.list
RUN echo "deb http://cdn.debian.net/debian/ stretch-updates main contrib" >> /etc/apt/sources.list.d/mirror.jp.list

RUN /bin/rm /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
        curl apt-utils apt-transport-https debconf-utils gcc build-essential \
        zlib1g-dev git gnupg2 unzip libfreetype6-dev libjpeg62-turbo-dev \
        libpng-dev libzip-dev libicu-dev vim git ssl-cert \
        && docker-php-ext-install -j$(nproc) zip gd mysqli pdo_mysql opcache intl \
        && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y libpq-dev \
        && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
        && docker-php-ext-install -j$(nproc) pgsql pdo_pgsql \
        && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y locales \
        && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
        && locale-gen

RUN pecl install apcu && echo "extension=apcu.so" > /usr/local/etc/php/conf.d/apc.ini

RUN if [ ! -d ${APACHE_DOCUMENT_ROOT} ]; then mkdir -p ${APACHE_DOCUMENT_ROOT} ; fi
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN a2enmod rewrite
RUN a2enmod headers

# Enable SSL
RUN a2enmod ssl
RUN ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf
EXPOSE 443

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
# Override with custom configuration settings
COPY dockerbuild/php.ini $PHP_INI_DIR/conf.d/

RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/bin/composer

COPY dockerbuild/.vimrc /root/

COPY dockerbuild/installEccube.sh /var/www/html
COPY dockerbuild/upload.tar.gz /var/www/html

RUN cd /var/www/html && chmod 755 upload.tar.gz && ./installEccube.sh

USER root

