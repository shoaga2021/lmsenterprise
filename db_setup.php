<?php
// One-time database setup script
// Access: https://your-app.up.railway.app/db_setup.php?token=setup2024
// DELETE THIS FILE after setup is complete

$token = $_GET['token'] ?? '';
if ($token !== 'setup2024') {
    die('Access denied. Append ?token=setup2024 to the URL.');
}

$host     = getenv('MYSQLHOST')     ?: 'localhost';
$user     = getenv('MYSQLUSER')     ?: 'root';
$pass     = getenv('MYSQLPASSWORD') ?: '';
$dbname   = getenv('MYSQLDATABASE') ?: 'ssnodb';
$port     = (int)(getenv('MYSQLPORT') ?: 3306);

$conn = new mysqli($host, $user, $pass, $dbname, $port);
if ($conn->connect_error) {
    die('<b>Connection failed:</b> ' . htmlspecialchars($conn->connect_error));
}
$conn->set_charset('utf8mb3');

$sql_file = __DIR__ . '/database_schema.sql';
if (!file_exists($sql_file)) {
    die('<b>Error:</b> database_schema.sql not found.');
}

$sql = file_get_contents($sql_file);

// Split into individual statements, stripping SQL line comments first
$statements = array_filter(
    array_map(function($s) {
        $lines = array_filter(
            explode("\n", trim($s)),
            fn($l) => strpos(trim($l), '--') !== 0 && strpos(trim($l), '---') !== 0
        );
        return trim(implode("\n", $lines));
    }, explode(';', $sql)),
    fn($s) => strlen($s) > 5
);

$ok = 0; $errors = [];
foreach ($statements as $stmt) {
    if ($conn->query($stmt) === TRUE) {
        $ok++;
    } else {
        $errors[] = htmlspecialchars($conn->error) . '<br><small>' . htmlspecialchars(substr($stmt, 0, 120)) . '...</small>';
    }
}
$conn->close();
?>
<!DOCTYPE html>
<html>
<head><title>DB Setup</title>
<style>body{font-family:sans-serif;max-width:800px;margin:40px auto;padding:0 20px}
.ok{color:green}.err{color:red}.box{background:#f5f5f5;padding:12px;border-radius:4px;margin:8px 0;font-size:13px}</style>
</head>
<body>
<h2>Smart School — Database Setup</h2>
<p class="ok">✅ <?= $ok ?> statements executed successfully.</p>
<?php if ($errors): ?>
<p class="err">⚠️ <?= count($errors) ?> errors (these may be harmless duplicates):</p>
<?php foreach ($errors as $e): ?>
<div class="box"><?= $e ?></div>
<?php endforeach; ?>
<?php endif; ?>
<hr>
<p><b>Next steps:</b></p>
<ol>
<li>Visit your app URL to confirm it loads.</li>
<li><b>Delete <code>db_setup.php</code> and <code>database_schema.sql</code> from your repo immediately.</b></li>
<li>Create an admin user — go to your app and log in.</li>
</ol>
</body>
</html>
