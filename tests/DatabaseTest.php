<?php

use PHPUnit\Framework\TestCase;

class DatabaseTest extends TestCase
{
	public function testSqlite(): void
	{
		$pdo = new PDO('sqlite::memory:', null, null, [
			PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_COLUMN,
		]);
		$statement = $pdo->prepare('select 1+1');
		$statement->execute();

		$this->assertSame(2, $statement->fetch());
	}
}
