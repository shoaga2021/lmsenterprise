<?php
// PHP built-in server router for CodeIgniter 3 on Railway/Render
if (php_sapi_name() === 'cli-server') {
    $path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
    $file = __DIR__ . $path;
    if (is_file($file)) {
        return false; // serve static files as-is
    }
}
require __DIR__ . '/index.php';
