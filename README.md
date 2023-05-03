Attempt to try out all PHP's PDO drivers with dockerized databases.

The drivers in [core codebase](https://github.com/php/php-src/tree/master/ext)
work. Some of the others don't. For now.

| Driver       | Supported DBs         | Chosen DB     | Notes |
|--------------|-----------------------|---------------|-------|
| PDO_CUBRID   | Cubrid                |               | [Appears abandoned since 2017](https://pecl.php.net/package/pdo_cubrid) |
| PDO_DBLIB    | Any FreeTDS-supported | MS SQL Server | |
| PDO_FIREBIRD | Firebird              | Firebird      | |
| PDO_IBM      | IBM DB2               |               | [Not updated for PHP8.2](https://pecl.php.net/package/pdo_ibm) |
| PDO_INFORMIX | Informix              |               | [Not updated for PHP8.2](https://pecl.php.net/package/pdo_informix) |
| PDO_MYSQL    | MySQL, MariaDB        | MySQL         | |
| PDO_OCI      | Oracle                | Oracle        | |
| PDO_ODBC     | Any ODBCv3-supported  | MS SQL Server | |
| PDO_PGSQL    | PostgreSQL            | PostgreSQL    | |
| PDO_SQLITE   | SQLite 2, SQLite 3    | SQLite 3      | |
| PDO_SQLSRV   | MS SQL Server         | MS SQL Server | |

## Usage

```sh
# Do stuff
docker compose run php [something something]

# E.g. get PHP version
docker compose run php -v

# Run a PHP script
docker compose run php php myscript.php

# Run composer
docker compose run php composer -V
```

Some `make` aliases for common actions:

```sh
# Install  dependencies
make install

# Run tests
make test

# Rebuild the PHP image (after dockerfile changes)
make build
```

## Informix setup

> **Note**
> My Informix install does not work and is commented out of the Dockerfile.

Informix SDK is not included. Download it [here](https://www.ibm.com/resources/mrs/assets/DownloadList?source=ifxdl&lang=en_US)
and put it in `/informix`.
