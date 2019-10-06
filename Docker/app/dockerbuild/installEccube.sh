#!/usr/bin/env bash

cd /var/www/html
tar -xzvf upload.tar.gz --strip-components 2
rm -f upload.tar.gz

cd /var/www
chmod 777 -R html/
cd html
composer install
