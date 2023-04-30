FROM php:8.2-cli

# Add composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install DB Drivers
# mysql
RUN docker-php-ext-install pdo_mysql && docker-php-ext-enable pdo_mysql

# pgsql
RUN set -eux; \
	apt-get update; \
	apt-get install -y \
		libpq-dev; \
	docker-php-ext-install pdo_pgsql; \
	docker-php-ext-enable pdo_pgsql; \
    apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*;

# sqlsrv
RUN set -eux; \
	apt-get update; \
    apt-get -y --no-install-recommends install gnupg; \
	curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -; \
    curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list; \
    apt-get update; \
    ACCEPT_EULA=Y apt-get -y --no-install-recommends install msodbcsql18 odbcinst=2.3.7 odbcinst1debian2=2.3.7 unixodbc=2.3.7 unixodbc-dev=2.3.7; \
    pecl install pdo_sqlsrv; \
	docker-php-ext-enable pdo_sqlsrv; \
    apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*;

# dblib
RUN set -eux; \
	apt-get update; \
    apt-get -y --no-install-recommends install \
		freetds-dev \
		freetds-bin; \
	docker-php-ext-install pdo_dblib; \
	docker-php-ext-enable pdo_dblib

WORKDIR /app
