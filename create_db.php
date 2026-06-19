<?php
/**
 * create_db.php
 * Detects database settings from application/config/database.php and offers to create the database if missing.
 * Access: http://localhost/school1/create_db.php
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

$config_file = __DIR__ . '/application/config/database.php';
$detected = array('hostname' => 'localhost', 'username' => 'root', 'password' => '', 'database' => '');

if (file_exists($config_file)) {
    $content = file_get_contents($config_file);
    if (preg_match("/'hostname'\s*=>\s*'([^']+)'/", $content, $m)) {
        $detected['hostname'] = $m[1];
    }
    if (preg_match("/'username'\s*=>\s*'([^']*)'/", $content, $m)) {
        $detected['username'] = $m[1];
    }
    if (preg_match("/'password'\s*=>\s*'([^']*)'/", $content, $m)) {
        $detected['password'] = $m[1];
    }
    if (preg_match("/'database'\s*=>\s*'([^']*)'/", $content, $m)) {
        $detected['database'] = $m[1];
    }
}

$message = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $host = $_POST['hostname'] ?? $detected['hostname'];
    $user = $_POST['username'] ?? $detected['username'];
    $pass = $_POST['password'] ?? $detected['password'];
    $db = $_POST['database'] ?? $detected['database'];

    if (empty($db)) {
        $message = "Please specify a database name.";
    } else {
        // Try connecting with provided credentials first
        $mysqli = @new mysqli($host, $user, $pass);
        if ($mysqli->connect_errno) {
            // If access denied, try fallback attempts (no password)
            $err = $mysqli->connect_error;
            if (stripos($err, 'access denied') !== false) {
                // Try with empty password (common for local WAMP default)
                $mysqli = @new mysqli($host, $user, '');
                if ($mysqli->connect_errno) {
                    $message = "Connection failed: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
                    $message .= "<br><br><strong>Hint:</strong> MySQL rejected the credentials. Try entering the correct MySQL root password in the form above or create the database via phpMyAdmin.";
                } else {
                    $message = "Connected using empty password fallback. Proceeding to create database...";
                }
            } else {
                $message = "Connection failed: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
            }
        } else {
            $sql = "CREATE DATABASE IF NOT EXISTS `" . str_replace('`', '', $db) . "` CHARACTER SET utf8 COLLATE utf8_general_ci";
            if ($mysqli->query($sql)) {
                $message = "Database '<strong>" . htmlspecialchars($db) . "</strong>' created or already exists.";
            } else {
                $message = "Failed to create database: " . $mysqli->error;
            }
            $mysqli->close();
        }
    }
}
?>
<!doctype html>
<html>

<head>
    <meta charset="utf-8">
    <title>Create Database - Smart School</title>
    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
            margin: 20px
        }

        label {
            display: block;
            margin-top: 10px
        }

        input {
            padding: 6px;
            width: 320px
        }

        button {
            margin-top: 12px;
            padding: 8px 14px
        }
    </style>
</head>

<body>
    <h2>Create Database for Smart School</h2>
    <p>This tool will attempt to create the database configured in <strong>application/config/database.php</strong>.</p>
    <?php if ($message): ?>
        <div style="padding:10px;background:#f0f0f0;border:1px solid #ddd;margin-bottom:12px"><?php echo $message; ?></div>
    <?php endif; ?>
    <form method="post">
        <label>MySQL Hostname
            <input name="hostname" value="<?php echo htmlspecialchars($detected['hostname']); ?>">
        </label>
        <label>MySQL Username
            <input name="username" value="<?php echo htmlspecialchars($detected['username']); ?>">
        </label>
        <label>MySQL Password
            <input name="password" value="<?php echo htmlspecialchars($detected['password']); ?>" autocomplete="off">
        </label>
        <label>Database Name
            <input name="database" value="<?php echo htmlspecialchars($detected['database']); ?>">
        </label>
        <button type="submit">Create Database</button>
    </form>
    <p>After creating the database, reload the site.</p>
</body>

</html>