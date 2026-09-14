<?php

declare(strict_types=1);

namespace CampusMarket;

use PDO;

final class Database
{
    private static ?PDO $connection = null;

    public static function connection(): PDO
    {
        if (self::$connection instanceof PDO) {
            return self::$connection;
        }

        $host = Env::get('DB_HOST', '127.0.0.1');
        $port = Env::get('DB_PORT', '3306');
        $database = Env::get('DB_DATABASE');
        $username = Env::get('DB_USERNAME');
        $password = Env::get('DB_PASSWORD', '');
        $sslCa = Env::get('DB_SSL_CA', '');

        if (!$database || !$username) {
            throw new \RuntimeException('Database settings are missing. Copy .env.example to .env and update it.');
        }

        $options = [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ];

        if ($sslCa !== '') {
            $sslCaPath = self::resolvePath($sslCa);
            if (!is_file($sslCaPath)) {
                throw new \RuntimeException("Database CA certificate was not found at {$sslCaPath}.");
            }

            $options[PDO::MYSQL_ATTR_SSL_CA] = $sslCaPath;
        }

        $dsn = "mysql:host={$host};port={$port};dbname={$database};charset=utf8mb4";
        self::$connection = new PDO($dsn, $username, $password, $options);

        return self::$connection;
    }

    private static function resolvePath(string $path): string
    {
        $isAbsolute = preg_match('/^(?:[A-Za-z]:[\\\\\/]|[\\\\\/]{2}|\/)/', $path) === 1;
        return $isAbsolute ? $path : dirname(__DIR__) . DIRECTORY_SEPARATOR . $path;
    }
}
