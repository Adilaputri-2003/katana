# Stage 1: build dependencies
FROM php:8.2-cli AS build
RUN apt-get update && apt-get install -y git unzip libzip-dev && docker-php-ext-install zip
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
WORKDIR /app
COPY . /app
RUN composer install --no-dev --prefer-dist --no-interaction --no-progress

# Stage 2: runtime
FROM php:8.2-cli
WORKDIR /app
COPY --from=build /app /app
EXPOSE 8000
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
