<?php

declare(strict_types=1);

require_once dirname(__DIR__) . '/backend/bootstrap.php';

use CampusMarket\Database;
use CampusMarket\Env;

$path = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?: '/';

if ($path === '/api/health') {
    header('Content-Type: application/json; charset=utf-8');

    try {
        Database::connection()->query('SELECT 1');
        echo json_encode([
            'status' => 'ok',
            'application' => 'Campus Market',
            'database' => 'connected',
        ], JSON_PRETTY_PRINT | JSON_THROW_ON_ERROR);
    } catch (Throwable $error) {
        http_response_code(503);
        $response = [
            'status' => 'setup_required',
            'application' => 'Campus Market',
            'database' => 'disconnected',
        ];

        if (Env::get('APP_DEBUG', 'false') === 'true') {
            $response['message'] = $error->getMessage();
        }

        echo json_encode($response, JSON_PRETTY_PRINT | JSON_THROW_ON_ERROR);
    }
    exit;
}

if ($path !== '/') {
    http_response_code(404);
    require dirname(__DIR__) . '/frontend/views/404.php';
    exit;
}

$databaseConnected = false;
try {
    Database::connection()->query('SELECT 1');
    $databaseConnected = true;
} catch (Throwable) {
    // The homepage stays available while a developer finishes local setup.
}

require dirname(__DIR__) . '/frontend/views/home.php';
