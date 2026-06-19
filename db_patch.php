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

// Fix: Correct column names and add missing columns to income / expenses / enquiry
$alter_stmts = [
    // income table — model uses inc_head_id, schema had income_head_id
    "ALTER TABLE `income` ADD COLUMN `inc_head_id` int(11) DEFAULT NULL",
    "ALTER TABLE `income` ADD COLUMN `name` varchar(150) DEFAULT NULL",
    "ALTER TABLE `income` ADD COLUMN `invoice_no` varchar(50) DEFAULT NULL",
    "ALTER TABLE `income` ADD COLUMN `documents` varchar(255) DEFAULT NULL",
    "ALTER TABLE `income` ADD COLUMN `note` text DEFAULT NULL",
    "ALTER TABLE `income` ADD COLUMN `session_id` int(11) DEFAULT NULL",
    "ALTER TABLE `income` ADD COLUMN `feetype_id` int(11) DEFAULT NULL",
    "ALTER TABLE `income` ADD COLUMN `class_id` int(11) DEFAULT NULL",
    // income_head — model selects income_head.class
    "ALTER TABLE `income_head` ADD COLUMN `class` tinyint(1) DEFAULT 0",
    // expenses table — model uses exp_head_id, schema had expense_head_id
    "ALTER TABLE `expenses` ADD COLUMN `exp_head_id` int(11) DEFAULT NULL",
    "ALTER TABLE `expenses` ADD COLUMN `name` varchar(150) DEFAULT NULL",
    "ALTER TABLE `expenses` ADD COLUMN `invoice_no` varchar(50) DEFAULT NULL",
    "ALTER TABLE `expenses` ADD COLUMN `documents` varchar(255) DEFAULT NULL",
    "ALTER TABLE `expenses` ADD COLUMN `note` text DEFAULT NULL",
    "ALTER TABLE `expenses` ADD COLUMN `session_id` int(11) DEFAULT NULL",
    "ALTER TABLE `expenses` ADD COLUMN `feetype_id` int(11) DEFAULT NULL",
    "ALTER TABLE `expenses` ADD COLUMN `class_id` int(11) DEFAULT NULL",
    // enquiry — model filters by status
    "ALTER TABLE `enquiry` ADD COLUMN `status` varchar(50) DEFAULT 'active'",
    // student_fees — model uses amount_detail JSON field
    "ALTER TABLE `student_fees` ADD COLUMN `amount_detail` text DEFAULT NULL",
    "ALTER TABLE `student_fees` ADD COLUMN `created_at` datetime DEFAULT CURRENT_TIMESTAMP",
    // student_fees_master — model uses amount, is_system, fee_amount
    "ALTER TABLE `student_fees_master` ADD COLUMN `is_system` tinyint(1) DEFAULT 0",
    "ALTER TABLE `student_fees_master` ADD COLUMN `fee_amount` decimal(10,2) DEFAULT 0.00",
    "ALTER TABLE `student_fees_master` ADD COLUMN `amount_detail` text DEFAULT NULL",
    // fee_receipt_no table might be missing rows
];
foreach ($alter_stmts as $sql) {
    $conn->query($sql);
    $err = $conn->error;
    if ($err && strpos($err, 'Duplicate column') === false && strpos($err, 'already exists') === false) {
        $steps[] = [substr($sql, 0, 65) . '...', '❌ ' . $err];
    } else {
        $steps[] = [substr($sql, 0, 65) . '...', 'OK'];
    }
}

// Fix: books and book_issues missing columns
$book_alters = [
    // books — model uses book_title, book_no, postdate; schema has title only
    "ALTER TABLE `books` ADD COLUMN `book_title` varchar(255) DEFAULT NULL",
    "ALTER TABLE `books` ADD COLUMN `book_no` varchar(50) DEFAULT NULL",
    "ALTER TABLE `books` ADD COLUMN `postdate` date DEFAULT NULL",
    // book_issues — model uses is_returned, duereturn_date; schema has return_status
    "ALTER TABLE `book_issues` ADD COLUMN `is_returned` tinyint(1) NOT NULL DEFAULT 0",
    "ALTER TABLE `book_issues` ADD COLUMN `duereturn_date` date DEFAULT NULL",
];
foreach ($book_alters as $sql) {
    $conn->query($sql);
    $err = $conn->error;
    if ($err && strpos($err, 'Duplicate column') === false) {
        $steps[] = [substr($sql, 0, 65) . '...', '❌ ' . $err];
    } else {
        $steps[] = [substr($sql, 0, 65) . '...', 'OK'];
    }
}

// Fix: Create admin user (skip if email already exists)
$admin_email = 'admin@school.com';
$admin_pass  = password_hash('admin123', PASSWORD_DEFAULT);
$check = $conn->query("SELECT id FROM `staff` WHERE email = '$admin_email' LIMIT 1");
if ($check && $check->num_rows === 0) {
    $conn->query("INSERT INTO `staff` (`name`, `email`, `password`, `is_active`, `gender`) VALUES ('Administrator', '$admin_email', '$admin_pass', 1, 'Male')");
    $staff_id = $conn->insert_id;
    if ($staff_id) {
        $conn->query("INSERT INTO `staff_roles` (`staff_id`, `role_id`) VALUES ($staff_id, 1)");
        $steps[] = ['Create admin user admin@school.com / admin123', $conn->error ?: 'OK'];
    } else {
        $steps[] = ['Create admin user', $conn->error ?: 'FAILED'];
    }
} else {
    $steps[] = ['Admin user already exists', 'SKIPPED'];
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
