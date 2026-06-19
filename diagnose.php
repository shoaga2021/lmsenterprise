<?php
/**
 * Smart School System Diagnostic Tool
 * Place this file in the root directory and access via: http://localhost/school1/diagnose.php
 * This script helps identify and troubleshoot installation issues.
 */

// Enable all error reporting
error_reporting(-1);
ini_set('display_errors', 1);

$diagnostics = array();
$warnings = array();
$errors = array();

// ===== PHP Version Check =====
$php_version = phpversion();
$diagnostics['PHP Version'] = $php_version;

if (version_compare($php_version, '5.6.0') < 0) {
    $errors[] = "PHP version is too old. Requires 5.6+, current: $php_version";
} elseif (version_compare($php_version, '7.0.0') < 0) {
    $warnings[] = "PHP 5.6 is outdated. Consider upgrading to PHP 7.x or 8.x";
}

// ===== PHP Extensions Check =====
$required_extensions = array(
    'mysqli' => 'MySQL Database Support',
    'gd' => 'Image Processing',
    'curl' => 'HTTP Requests',
    'mbstring' => 'Multi-byte Strings',
    'zip' => 'ZIP File Support'
);

$extensions_status = array();
foreach ($required_extensions as $ext => $desc) {
    if (extension_loaded($ext)) {
        $extensions_status[$ext] = "✓ Enabled - $desc";
    } else {
        $extensions_status[$ext] = "✗ MISSING - $desc";
        $errors[] = "PHP Extension missing: $ext ($desc)";
    }
}
$diagnostics['PHP Extensions'] = $extensions_status;

// ===== PHP Configuration Check =====
$php_settings = array(
    'allow_url_fopen' => ini_get('allow_url_fopen'),
    'max_execution_time' => ini_get('max_execution_time'),
    'memory_limit' => ini_get('memory_limit'),
    'upload_max_filesize' => ini_get('upload_max_filesize'),
    'post_max_size' => ini_get('post_max_size'),
    'file_uploads' => ini_get('file_uploads')
);
$diagnostics['PHP Configuration'] = $php_settings;

if (ini_get('allow_url_fopen') != '1') {
    $warnings[] = "allow_url_fopen is disabled - Some features may not work";
}

// ===== File Permissions Check =====
$app_path = dirname(__FILE__);
$folders_to_check = array(
    'application/config' => 'Config Files',
    'temp' => 'Temporary Files',
    'uploads' => 'Upload Directory'
);

$permissions_status = array();
foreach ($folders_to_check as $folder => $desc) {
    $full_path = $app_path . '/' . $folder;
    if (is_dir($full_path)) {
        $is_writable = is_writable($full_path);
        $perms = substr(sprintf('%o', fileperms($full_path)), -4);

        if ($is_writable) {
            $permissions_status[$folder] = "✓ Writable ($desc) - Perms: $perms";
        } else {
            $permissions_status[$folder] = "✗ NOT Writable ($desc) - Perms: $perms";
            $errors[] = "Directory not writable: $folder (Permissions: $perms)";
        }
    } else {
        $permissions_status[$folder] = "✗ Directory not found: $folder";
        $errors[] = "Directory missing: $folder";
    }
}
$diagnostics['File Permissions'] = $permissions_status;

// ===== MySQL Connection Check =====
$mysql_status = "Not Checked";
$mysql_info = "---";

if (extension_loaded('mysqli')) {
    $mysql_host = isset($_POST['mysql_host']) ? $_POST['mysql_host'] : 'localhost';
    $mysql_user = isset($_POST['mysql_user']) ? $_POST['mysql_user'] : 'root';
    $mysql_pass = isset($_POST['mysql_pass']) ? $_POST['mysql_pass'] : '';
    $mysql_db = isset($_POST['mysql_db']) ? $_POST['mysql_db'] : '';

    if (isset($_POST['test_mysql'])) {
        $connection = @mysqli_connect($mysql_host, $mysql_user, $mysql_pass);

        if ($connection) {
            $mysql_status = "✓ Connected to MySQL";
            $mysql_info = "Server: $mysql_host | User: $mysql_user";

            // Check for specific database
            if ($mysql_db) {
                $db_exists = mysqli_select_db($connection, $mysql_db);
                if ($db_exists) {
                    $mysql_status .= " | Database '$mysql_db' found";
                } else {
                    $warnings[] = "Database '$mysql_db' not found on MySQL server";
                    $mysql_status .= " | Database '$mysql_db' NOT FOUND";
                }
            }

            // Get MySQL version
            $result = mysqli_query($connection, "SELECT VERSION()");
            $version_row = mysqli_fetch_row($result);
            $mysql_version = $version_row[0];
            $mysql_info = "MySQL Version: $mysql_version | Server: $mysql_host | User: $mysql_user";

            mysqli_close($connection);
        } else {
            $error = mysqli_connect_error();
            $mysql_status = "✗ MySQL Connection Failed";
            $mysql_info = "Error: $error";
            $errors[] = "Cannot connect to MySQL: $error";
        }
    }
}
$diagnostics['MySQL Connection'] = array('Status' => $mysql_status, 'Info' => $mysql_info);

// ===== Server Information =====
$server_info = array(
    'Server Software' => isset($_SERVER['SERVER_SOFTWARE']) ? $_SERVER['SERVER_SOFTWARE'] : 'Unknown',
    'Server OS' => php_uname('s'),
    'Server IP' => isset($_SERVER['SERVER_ADDR']) ? $_SERVER['SERVER_ADDR'] : 'Unknown',
    'Document Root' => isset($_SERVER['DOCUMENT_ROOT']) ? $_SERVER['DOCUMENT_ROOT'] : 'Unknown',
    'Current Directory' => dirname(__FILE__)
);
$diagnostics['Server Information'] = $server_info;

// ===== Determine Overall Status =====
$status = 'OK';
if (!empty($errors)) {
    $status = 'CRITICAL';
} elseif (!empty($warnings)) {
    $status = 'WARNING';
}

?>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart School - System Diagnostics</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        h1 {
            color: #333;
        }

        h2 {
            color: #555;
            border-bottom: 2px solid #ddd;
            padding-bottom: 10px;
            margin-top: 30px;
        }

        .status {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-weight: bold;
            font-size: 18px;
        }

        .status.ok {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .status.warning {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeeba;
        }

        .status.critical {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .diagnostic-item {
            padding: 10px;
            margin: 10px 0;
            border-left: 4px solid #ddd;
            background-color: #f9f9f9;
        }

        .diagnostic-item strong {
            color: #333;
        }

        .alert {
            padding: 15px;
            margin: 10px 0;
            border-radius: 5px;
        }

        .alert.error {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }

        .alert.warning {
            background-color: #fff3cd;
            border: 1px solid #ffeeba;
            color: #856404;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 15px 0;
        }

        th,
        td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #f8f9fa;
            font-weight: bold;
        }

        tr:hover {
            background-color: #f5f5f5;
        }

        .form-group {
            margin: 15px 0;
        }

        label {
            display: inline-block;
            width: 150px;
            font-weight: bold;
        }

        input[type="text"],
        input[type="password"] {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 3px;
            width: 200px;
        }

        button {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-weight: bold;
        }

        button:hover {
            background-color: #0056b3;
        }

        .success {
            color: #28a745;
            font-weight: bold;
        }

        .error-text {
            color: #dc3545;
            font-weight: bold;
        }

        .warning-text {
            color: #ffc107;
            font-weight: bold;
        }
    </style>
</head>

<body>
    <div class="container">
        <h1>🔍 Smart School - System Diagnostics</h1>

        <div class="status <?php echo strtolower($status); ?>">
            Status: <?php echo $status; ?>
        </div>

        <?php if (!empty($errors)): ?>
            <h2>❌ Critical Errors</h2>
            <?php foreach ($errors as $error): ?>
                <div class="alert error">
                    <strong>Error:</strong> <?php echo htmlspecialchars($error); ?>
                </div>
            <?php endforeach; ?>
        <?php endif; ?>

        <?php if (!empty($warnings)): ?>
            <h2>⚠️ Warnings</h2>
            <?php foreach ($warnings as $warning): ?>
                <div class="alert warning">
                    <strong>Warning:</strong> <?php echo htmlspecialchars($warning); ?>
                </div>
            <?php endforeach; ?>
        <?php endif; ?>

        <h2>📋 System Information</h2>
        <?php foreach ($diagnostics['Server Information'] as $key => $value): ?>
            <div class="diagnostic-item">
                <strong><?php echo $key; ?>:</strong> <?php echo htmlspecialchars($value); ?>
            </div>
        <?php endforeach; ?>

        <h2>✅ PHP Configuration</h2>
        <table>
            <tr>
                <th>Setting</th>
                <th>Value</th>
            </tr>
            <?php foreach ($diagnostics['PHP Configuration'] as $key => $value): ?>
                <tr>
                    <td><?php echo htmlspecialchars($key); ?></td>
                    <td><?php echo htmlspecialchars($value); ?></td>
                </tr>
            <?php endforeach; ?>
        </table>

        <h2>📦 PHP Extensions</h2>
        <table>
            <tr>
                <th>Extension</th>
                <th>Status</th>
            </tr>
            <?php foreach ($diagnostics['PHP Extensions'] as $ext => $status): ?>
                <tr>
                    <td><?php echo htmlspecialchars($ext); ?></td>
                    <td><?php echo htmlspecialchars($status); ?></td>
                </tr>
            <?php endforeach; ?>
        </table>

        <h2>🔐 File Permissions</h2>
        <table>
            <tr>
                <th>Directory</th>
                <th>Status</th>
            </tr>
            <?php foreach ($diagnostics['File Permissions'] as $folder => $status): ?>
                <tr>
                    <td><?php echo htmlspecialchars($folder); ?></td>
                    <td><?php echo htmlspecialchars($status); ?></td>
                </tr>
            <?php endforeach; ?>
        </table>

        <h2>🗄️ MySQL Connection Test</h2>
        <form method="POST">
            <div class="form-group">
                <label for="mysql_host">MySQL Host:</label>
                <input type="text" id="mysql_host" name="mysql_host"
                    value="<?php echo isset($_POST['mysql_host']) ? htmlspecialchars($_POST['mysql_host']) : 'localhost'; ?>">
            </div>
            <div class="form-group">
                <label for="mysql_user">MySQL User:</label>
                <input type="text" id="mysql_user" name="mysql_user"
                    value="<?php echo isset($_POST['mysql_user']) ? htmlspecialchars($_POST['mysql_user']) : 'root'; ?>">
            </div>
            <div class="form-group">
                <label for="mysql_pass">MySQL Password:</label>
                <input type="password" id="mysql_pass" name="mysql_pass" value="">
            </div>
            <div class="form-group">
                <label for="mysql_db">Database Name (optional):</label>
                <input type="text" id="mysql_db" name="mysql_db"
                    value="<?php echo isset($_POST['mysql_db']) ? htmlspecialchars($_POST['mysql_db']) : ''; ?>">
            </div>
            <input type="hidden" name="test_mysql" value="1">
            <button type="submit">Test Connection</button>
        </form>

        <div class="diagnostic-item" style="margin-top: 20px;">
            <strong>MySQL Status:</strong>
            <span class="<?php echo strpos($mysql_status, '✗') ? 'error-text' : 'success'; ?>">
                <?php echo htmlspecialchars($mysql_status); ?>
            </span>
            <br>
            <strong>Details:</strong> <?php echo htmlspecialchars($mysql_info); ?>
        </div>

        <h2>📖 Quick Links</h2>
        <ul>
            <li><a href="/school1/install">Start Installation</a></li>
            <li><a href="/phpmyadmin">phpMyAdmin (Database Management)</a></li>
            <li><a href="/school1/SETUP_GUIDE.md">View Setup Guide</a></li>
        </ul>

        <hr>
        <p style="color: #666; font-size: 12px;">
            <strong>Note:</strong> After installation is complete, delete this file (diagnose.php) for security reasons.
        </p>
    </div>
</body>

</html>