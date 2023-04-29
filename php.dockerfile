FROM php:8.2-cli

# Add composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# install dependencies
RUN docker-php-ext-install pdo_mysql && docker-php-ext-enable pdo_mysql

WORKDIR /app
