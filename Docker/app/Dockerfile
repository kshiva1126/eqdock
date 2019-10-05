FROM php:7.1-apache

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    sudo \
    git \
    libxml2-dev \
    unzip \
    wget \
    zlib1g-dev \
    iproute2 \
    libsqlite3-dev \
    libpq-dev \
    libicu-dev \
    gnupg2
RUN wget -qO- https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y --no-install-recommends nodejs

RUN apt-get update \
    && apt-get install -y \
    vim

RUN apt-get update \
    && apt-get install -y \
    locales \
    locales-all \
    && locale-gen ja_JP.UTF-8 && update-locale \
    && echo "export LANG=ja_JP.UTF-8" >> ~/.bashrc

RUN docker-php-ext-install \
    intl \
    mbstring \
    pdo \
    pdo_sqlite \
    pdo_mysql \
    pdo_pgsql \
    soap \
    xml \
    zip

# RUN pecl install xdebug
RUN pecl install apcu
RUN docker-php-ext-enable \
    apcu \
    opcache \
    && a2enmod rewrite \
    && apt-get clean \
    && rm -rf /tmp/*
RUN curl -sS https://getcomposer.org/installer \
    |  php -- \
    --filename=composer \
    --install-dir=/usr/local/bin \
    # composerの高速化
    && COMPOSER_ALLOW_SUPERUSER=1 composer global require --optimize-autoloader "hirak/prestissimo" \
    && chown www-data /var/www \
    && chmod g+s /var/www/html

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

COPY ./php.ini /usr/local/etc/php/
COPY ./.vimrc /root/

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
EXPOSE 80

CMD ["apache2-foreground"]
