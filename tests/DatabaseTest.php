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
		$driverName = $pdo->getAttribute(PDO::ATTR_DRIVER_NAME);

		// Assure that we've actually used the correct prefix in the DSN
		$this->assertStringContainsStringIgnoringCase($driverName, $this->dataName());

		$statement = $pdo->prepare($this->getSql($driverName));
		$statement->execute();

		$this->assertEquals(2, $statement->fetch());
	}

	protected function getSql(string $driverName): string
	{
		$sql = 'select 1 + 1';

		// Oracle can't select without FROM, use their special dummy table
		if('oci' === $driverName)
			return $sql.' from dual';

		// Firebird can't select without FROM, use their special dummy table
		if('firebird' === $driverName)
			return $sql.' from RDB$DATABASE';

		return $sql;
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
			// 'PDO_CUBRID' => ["cubrid:host=cubrid;dbname=$db", $user, $pass],
			'PDO_DBLIB' => ["dblib:host=mssql;dbname=master", 'SA', $pass],
			'PDO_FIREBIRD' => ["firebird:dbname=firebird/3050:/firebird/data/$db", $user, $pass],
			// 'PDO_IBM' => ["dblib:host=mssql;dbname=master", 'SA', $pass],
			// 'PDO_INFORMIX' => ["informix:host=informix; service=9088; database=sysmaster; server=informix; protocol=onsoctcp", 'informix', 'in4mix'],
			'PDO_MYSQL' => ["mysql:host=mysql;port=3306;dbname=$db", $user, $pass],
			'PDO_OCI' => [
				"oci:dbname=(DESCRIPTION =
					(ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = oracle)(PORT = 1521)))
					(CONNECT_DATA = (SERVICE_NAME = XEPDB1)))
				", $user, $pass],
			'PDO_ODBC' => ["odbc:Driver=ODBC Driver 18 for SQL Server;Server=mssql;TrustServerCertificate=YES", 'SA', $pass],
			'PDO_PGSQL' => ["pgsql:host=postgres;port=5432;dbname=$db", $user, $pass],
			'PDO_SQLITE' => ['sqlite::memory:', null, null],
			'PDO_SQLSRV' => ["sqlsrv:Server=mssql;Database=master;TrustServerCertificate=1", 'SA', $pass],
		];
	}
}
