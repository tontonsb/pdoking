FROM php:8.2-cli

# Add composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

WORKDIR /app
