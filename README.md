Attempt to try out all PHP's PDO drivers with dockerized databases.

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
```
