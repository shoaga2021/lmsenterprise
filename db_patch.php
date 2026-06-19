<?php
// One-time database patch script
// Access: https://your-app.up.railway.app/db_patch.php?token=patch2024
// DELETE THIS FILE after running

$token = $_GET['token'] ?? '';
if ($token !== 'patch2024') {
    die('Access denied. Append ?token=patch2024 to the URL.');
}

$host   = getenv('MYSQLHOST')     ?: 'localhost';
$user   = getenv('MYSQLUSER')     ?: 'root';
$pass   = getenv('MYSQLPASSWORD') ?: '';
$dbname = getenv('MYSQLDATABASE') ?: 'ssnodb';
$port   = (int)(getenv('MYSQLPORT') ?: 3306);

$conn = new mysqli($host, $user, $pass, $dbname, $port);
if ($conn->connect_error) {
    die('<b>Connection failed:</b> ' . htmlspecialchars($conn->connect_error));
}
$conn->set_charset('utf8mb3');

$steps = [];

// Fix 1: Drop and recreate captcha table with correct schema
$conn->query("DROP TABLE IF EXISTS `captcha`");
$steps[] = ['Drop old captcha table', $conn->error ?: 'OK'];

$conn->query("CREATE TABLE `captcha` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3");
$steps[] = ['Create correct captcha table', $conn->error ?: 'OK'];

$conn->query("INSERT IGNORE INTO `captcha` (`name`, `status`) VALUES
  ('login', 0), ('userlogin', 0), ('admission', 0)");
$steps[] = ['Seed captcha rows', $conn->error ?: 'OK'];

// Fix 2: Ensure email_config has a default row (mailer needs it)
$res = $conn->query("SELECT COUNT(*) as c FROM `email_config`");
$row = $res ? $res->fetch_assoc() : ['c' => 0];
if ((int)$row['c'] === 0) {
    $conn->query("INSERT INTO `email_config` (`type`, `is_active`) VALUES ('smtp', 0)");
    $steps[] = ['Seed email_config default row', $conn->error ?: 'OK'];
} else {
    $steps[] = ['email_config already has data', 'SKIPPED'];
}

// Fix 3: Add missing columns to front_cms_programs
$cols = [
    "ALTER TABLE `front_cms_programs` ADD COLUMN `type` varchar(100) DEFAULT NULL",
    "ALTER TABLE `front_cms_programs` ADD COLUMN `created_at` datetime DEFAULT CURRENT_TIMESTAMP",
    "ALTER TABLE `front_cms_programs` ADD COLUMN `image` varchar(255) DEFAULT NULL",
    "ALTER TABLE `front_cms_programs` ADD COLUMN `short_description` text DEFAULT NULL",
    "ALTER TABLE `front_cms_programs` ADD COLUMN `category_id` int(11) DEFAULT NULL",
    "ALTER TABLE `front_cms_programs` ADD COLUMN `session_id` int(11) DEFAULT NULL",
    "ALTER TABLE `front_cms_programs` ADD COLUMN `date` date DEFAULT NULL",
];
foreach ($cols as $sql) {
    $conn->query($sql);
    $err = $conn->error;
    // Ignore "Duplicate column" errors — column already exists
    if ($err && strpos($err, 'Duplicate column') === false) {
        $steps[] = [substr($sql, 0, 60) . '...', $err];
    } else {
        $steps[] = [substr($sql, 0, 60) . '...', 'OK'];
    }
}

// Fix 5: Ensure sms_config / smsgateway_setting table has a row if it exists
$has_sms = $conn->query("SHOW TABLES LIKE 'sms_config'");
if ($has_sms && $has_sms->num_rows > 0) {
    $res2 = $conn->query("SELECT COUNT(*) as c FROM `sms_config`");
    $row2 = $res2 ? $res2->fetch_assoc() : ['c' => 0];
    if ((int)$row2['c'] === 0) {
        $conn->query("INSERT INTO `sms_config` (`type`, `is_active`) VALUES ('textlocal', 0)");
        $steps[] = ['Seed sms_config', $conn->error ?: 'OK'];
    } else {
        $steps[] = ['sms_config already has data', 'SKIPPED'];
    }
}

$conn->close();
?>
<!DOCTYPE html>
<html>
<head><title>DB Patch</title>
<style>body{font-family:sans-serif;max-width:700px;margin:40px auto;padding:0 20px}
.ok{color:green}.err{color:red}.box{background:#f5f5f5;padding:10px;border-radius:4px;margin:6px 0;font-size:13px;display:flex;gap:12px}</style>
</head>
<body>
<h2>Smart School — Database Patch</h2>
<?php foreach ($steps as [$label, $result]): ?>
<div class="box">
  <span><?= $result === 'OK' || $result === 'SKIPPED' ? '✅' : '❌' ?></span>
  <span><b><?= htmlspecialchars($label) ?></b><br><small><?= htmlspecialchars($result) ?></small></span>
</div>
<?php endforeach; ?>
<hr>
<p><b>Done.</b> Delete <code>db_patch.php</code> from your repo after this.</p>
<p><a href="/site/userlogin">→ Try the login page</a></p>
</body>
</html>
