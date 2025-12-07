# Stage 1: build dependencies
FROM php:8.2-cli AS build
RUN apt-get update && apt-get install -y git unzip libzip-dev && docker-php-ext-install zip
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . /app

# Allow insecure packages (legacy project)
RUN composer config --global --no-plugins allow-plugins.composer/audit false
RUN composer config --global --no-plugins allow-plugins true
RUN composer config --global --no-plugins block-insecure false

RUN COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --prefer-dist --no-interaction --no-ansi --verbose
