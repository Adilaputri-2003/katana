# Stage 1: build dependencies
FROM php:8.2-cli AS build

RUN apt-get update && apt-get install -y \
    git unzip zip libzip-dev libicu-dev libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install intl mbstring pdo pdo_mysql bcmath zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . /app

RUN COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --prefer-dist --no-interaction --no-ansi --verbose

# Stage 2: runtime image
FROM php:8.2-cli

WORKDIR /app
COPY --from=build /app /app

ENV APP_ENV=production
ENV APP_KEY=base64:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=

EXPOSE 8000
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
