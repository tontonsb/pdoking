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

		return [
			'SQLite' => ['sqlite::memory:', null, null],
			'MySQL' => ["mysql:host=mysql;port=3306;dbname=$db", $user, $pass],
			'PostgreSQL' => ["pgsql:host=postgres;port=5432;dbname=$db", $user, $pass],
		];
	}
}
