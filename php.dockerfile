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

# odbc, unixodbc and msodbcsql18 deps are already installed, driver is ready in /etc/odbcinst.ini
RUN set -eux; \
	docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr; \
	docker-php-ext-install pdo_odbc; \
	docker-php-ext-enable pdo_odbc;

# oci
RUN set -eux; \
	apt-get update; \
	apt-get -y --no-install-recommends install \
		wget \
		unzip \
		libaio1; \
	mkdir -p /opt/oracle; \
	cd /opt/oracle; \
	wget https://download.oracle.com/otn_software/linux/instantclient/2110000/instantclient-basic-linux.x64-21.10.0.0.0dbru.zip; \
	wget https://download.oracle.com/otn_software/linux/instantclient/2110000/instantclient-sdk-linux.x64-21.10.0.0.0dbru.zip; \
	unzip instantclient-basic-linux.x64-21.10.0.0.0dbru.zip; \
	unzip instantclient-sdk-linux.x64-21.10.0.0.0dbru.zip; \
	echo /opt/oracle/instantclient_21_10 > /etc/ld.so.conf.d/oracle-instantclient.conf; \
	ln -s /opt/oracle/instantclient_21_10 /opt/oracle/instantclient; \
	ldconfig; \
	docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/opt/oracle/instantclient; \
	docker-php-ext-install pdo_oci; \
	docker-php-ext-enable pdo_oci;

# firebird
RUN set -eux; \
	apt-get update; \
	apt-get -y --no-install-recommends install \
		firebird-dev; \
	docker-php-ext-install pdo_firebird; \
	docker-php-ext-enable pdo_firebird;

# cubrid
# RUN set -eux; \
# 	apt-get update; \
# 	apt-get -y --no-install-recommends install \
# 		wget; \
# 	cd /tmp; \
# 	wget http://ftp.cubrid.org/CUBRID_Engine/11.2_latest/CUBRID-11.2-latest-Linux.x86_64.sh; \
# 	chmod a+x CUBRID-11.2-latest-Linux.x86_64.sh; \
# 	mkdir -p /opt/cubrid; \
# 	# The script includes an interactive prompt
# 	echo y | ./CUBRID-11.2-latest-Linux.x86_64.sh --skip-license --exclude-subdir --prefix=/opt/cubrid; \
# 	rm /tmp/CUBRID-11.2-latest-Linux.x86_64.sh; \
# 	pecl install --configureoptions 'with-pdo-cubrid=/opt/cubrid' pdo_cubrid; \
# 	docker-php-ext-enable pdo_cubrid;

# informix
# Get informix SDK and put it in /informix
# https://www.ibm.com/resources/mrs/assets/DownloadList?source=ifxdl&lang=en_US
# RUN set -eux; \
#	docker-php-ext-configure pdo_informix --with-pdo-informix=/app/informix; \
#	docker-php-ext-install pdo_informix; \
#	docker-php-ext-enable pdo_informix;

WORKDIR /app
