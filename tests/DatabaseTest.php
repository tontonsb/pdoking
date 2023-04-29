<?php

use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\TestCase;

class DatabaseTest extends TestCase
{
	#[DataProvider('databases')]
	public function testAdditionInDatabase(string $dsn, ?string $username, ?string $password): void
	{
		$pdo = new PDO($dsn, $username, $password, [
			PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_COLUMN,
		]);

		$statement = $pdo->prepare('select 1+1');
		$statement->execute();

		$this->assertSame(2, $statement->fetch());
	}

	public static function databases():array
	{
		$db = getenv('DB_DATABASE');
		$user = getenv('DB_USERNAME');
		$pass = getenv('DB_PASSWORD');

		/*
			Driver name		Supported databases
			PDO_CUBRID		Cubrid
			PDO_DBLIB		FreeTDS / Microsoft SQL Server / Sybase
			PDO_FIREBIRD	Firebird
			PDO_IBM			IBM DB2
			PDO_INFORMIX	IBM Informix Dynamic Server
			PDO_MYSQL		MySQL 3.x/4.x/5.x/8.x
			PDO_OCI			Oracle Call Interface
			PDO_ODBC		ODBC v3 (IBM DB2, unixODBC and win32 ODBC)
			PDO_PGSQL		PostgreSQL
			PDO_SQLITE		SQLite 3 and SQLite 2
			PDO_SQLSRV		Microsoft SQL Server / SQL Azure
		 */

		return [
			'SQLite' => ['sqlite::memory:', null, null],
			'MySQL' => ["mysql:host=mysql;port=3306;dbname=$db", $user, $pass],
			'PostgreSQL' => ["pgsql:host=postgres;port=5432;dbname=$db", $user, $pass],
		];
	}
}
