# Stage 1: build dependencies
FROM php:8.2-cli AS build
RUN apt-get update && apt-get install -y git unzip libzip-dev && docker-php-ext-install zip
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . /app

RUN COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --prefer-dist --no-interaction --no-ansi --verbose --ignore-platform-reqs
