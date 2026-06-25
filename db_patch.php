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

// ── CI3 database-session table ─────────────────────────────────────────────────
// Must exist before any request tries to read/write the session.
$conn->query("
CREATE TABLE IF NOT EXISTS `ci_sessions` (
    `id`         VARCHAR(128)     NOT NULL,
    `ip_address` VARCHAR(45)      NOT NULL,
    `timestamp`  INT(10) UNSIGNED NOT NULL DEFAULT 0,
    `data`       BLOB             NOT NULL,
    PRIMARY KEY (`id`),
    KEY `ci_sessions_timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
");
$steps[] = ['Create ci_sessions table', $conn->error ?: 'OK'];

// ── Seed languages (id=1 English) — required by sch_settings INNER JOIN ───────
// Setting_model::get() does INNER JOIN languages on sch_settings.lang_id.
// If the row is absent the JOIN returns no rows and every $result[0] fatals.
$res_lang = $conn->query("SELECT COUNT(*) as c FROM `languages` WHERE id = 1");
$cnt_lang  = $res_lang ? $res_lang->fetch_assoc()['c'] : 0;
if ((int)$cnt_lang === 0) {
    $conn->query("INSERT INTO `languages` (`id`,`language`,`short_code`,`is_rtl`) VALUES (1,'English','en',0)");
    $steps[] = ['Seed languages id=1 (English)', $conn->error ?: 'OK'];
} else {
    $steps[] = ['languages id=1 already exists', 'SKIPPED'];
}

// ── Seed sessions (id=1 2024-25) — required by sch_settings INNER JOIN ────────
$res_ses = $conn->query("SELECT COUNT(*) as c FROM `sessions` WHERE id = 1");
$cnt_ses  = $res_ses ? $res_ses->fetch_assoc()['c'] : 0;
if ((int)$cnt_ses === 0) {
    $conn->query("INSERT INTO `sessions` (`id`,`session`,`is_active`) VALUES (1,'2024-25',1)");
    $steps[] = ['Seed sessions id=1 (2024-25)', $conn->error ?: 'OK'];
} else {
    $steps[] = ['sessions id=1 already exists', 'SKIPPED'];
}

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

// Fix: events table missing columns used by Calendar_model
$event_cols = [
    "ALTER TABLE `events` ADD COLUMN `event_type` varchar(50)  DEFAULT 'public'",
    "ALTER TABLE `events` ADD COLUMN `event_for`  int(11)      DEFAULT 0",
    "ALTER TABLE `events` ADD COLUMN `role_id`    int(11)      DEFAULT 0",
    "ALTER TABLE `events` ADD COLUMN `is_active`  varchar(10)  DEFAULT 'yes'",
    "ALTER TABLE `events` ADD COLUMN `start_date` date         DEFAULT NULL",
];
foreach ($event_cols as $sql) {
    $conn->query($sql);
    $err = $conn->error;
    if ($err && strpos($err, 'Duplicate column') === false) {
        $steps[] = [substr($sql, 0, 65) . '...', '❌ ' . $err];
    } else {
        $steps[] = [substr($sql, 0, 65) . '...', 'OK'];
    }
}

// ── NEW FIX: roles table needs "Super Admin" so hasPrivilege() grants all access ──
// The RBAC library checks: if role name == 'Super Admin' → grant everything
// Original schema seeded id=1 as 'Admin' — rename it to 'Super Admin'.
$conn->query("UPDATE `roles` SET `name` = 'Super Admin' WHERE `id` = 1 AND `name` = 'Admin'");
$steps[] = ['Rename role id=1 to Super Admin (RBAC bypass)', $conn->affected_rows > 0 ? 'OK (renamed)' : ($conn->error ?: 'SKIPPED (already named Super Admin)')];

// ── NEW FIX: permission_group (modules) table – seed all modules as active ──
// Module_lib loads from permission_group; if empty, hasActive() always returns
// false and every dashboard widget/sidebar section is hidden.
$modules = [
    ['front_office',        0, 1, 0, 0],
    ['student_information', 0, 1, 0, 0],
    ['online_admission',    0, 1, 0, 0],
    ['multi_class',         0, 1, 0, 0],
    ['fees_collection',     0, 1, 0, 0],
    ['income',              0, 1, 0, 0],
    ['expense',             0, 1, 0, 0],
    ['student_attendance',  0, 1, 0, 0],
    ['examination',         0, 1, 0, 0],
    ['online_examination',  0, 1, 0, 0],
    ['lesson_plan',         0, 1, 0, 0],
    ['academics',           0, 1, 0, 0],
    ['human_resource',      0, 1, 0, 0],
    ['communicate',         0, 1, 0, 0],
    ['zoom_live_classes',   0, 1, 0, 0],
    ['gmeet_live_classes',  0, 1, 0, 0],
    ['download_center',     0, 1, 0, 0],
    ['homework',            0, 1, 0, 0],
    ['library',             0, 1, 0, 0],
    ['inventory',           0, 1, 0, 0],
    ['transport',           0, 1, 0, 0],
    ['hostel',              0, 1, 0, 0],
    ['certificate',         0, 1, 0, 0],
    ['front_cms',           0, 1, 0, 0],
    ['alumni',              0, 1, 0, 0],
    ['reports',             0, 1, 0, 0],
    ['system_settings',     1, 1, 0, 0],
    ['calendar_to_do_list', 0, 1, 0, 0],
    ['chat',                0, 1, 0, 0],
    ['fees',                0, 1, 1, 1],
    ['attendance',          0, 1, 1, 1],
    ['examinations',        0, 1, 1, 1],
    ['notice_board',        0, 1, 1, 1],
    ['teachers_rating',     0, 1, 1, 0],
    ['transport_routes',    0, 1, 1, 1],
    ['hostel_rooms',        0, 1, 1, 0],
    ['class_timetable',     0, 1, 1, 0],
    ['syllabus_status',     0, 1, 1, 0],
    ['apply_leave',         0, 1, 1, 0],
    ['live_classes',        0, 1, 1, 0],
];
foreach ($modules as [$sc, $sys, $active, $stu, $par]) {
    $existing = $conn->query("SELECT id FROM `permission_group` WHERE `short_code` = '$sc' LIMIT 1");
    if ($existing && $existing->num_rows === 0) {
        $conn->query("INSERT INTO `permission_group` (`short_code`,`system`,`is_active`,`student`,`parent`) VALUES ('$sc',$sys,$active,$stu,$par)");
        $err = $conn->error;
        $steps[] = ["Seed module: $sc", $err ?: 'OK'];
    } else {
        $steps[] = ["Module already exists: $sc", 'SKIPPED'];
    }
}

// ── NEW FIX: sch_settings default row ──
// getSetting() / get() do INNER JOIN sessions+languages on sch_settings.
// If the table is empty those queries return null and the dashboard fatals.
$chk = $conn->query("SELECT COUNT(*) as c FROM `sch_settings`");
$cnt = $chk ? $chk->fetch_assoc()['c'] : 0;
if ((int)$cnt === 0) {
    $conn->query("INSERT INTO `sch_settings`
        (`name`,`email`,`phone`,`address`,`session_id`,`lang_id`,
         `currency`,`currency_symbol`,`currency_place`,
         `date_format`,`time_format`,`timezone`,
         `start_month`,`start_week`,`theme`,
         `attendence_type`,`is_rtl`,`class_teacher`,
         `adm_prefix`,`adm_start_from`,`adm_no_digit`,
         `adm_update_status`,`adm_auto_insert`,
         `staffid_prefix`,`staffid_start_from`,`staffid_no_digit`,
         `staffid_update_status`,`staffid_auto_insert`,
         `online_admission`,`is_duplicate_fees_invoice`,
         `is_student_house`,`is_blood_group`,`roll_no`,
         `student_profile_edit`,`fee_due_days`)
      VALUES
        ('Smart School','admin@school.com','','',1,1,
         'USD','$','before',
         'd-m-Y','h:i A','UTC',
         1,'Sunday','default',
         0,'disabled','no',
         'ADM',1,4,
         0,0,
         'STAFF',1,4,
         0,0,
         0,0,
         0,0,0,
         0,0)");
    $steps[] = ['Seed sch_settings default row', $conn->error ?: 'OK'];
} else {
    $steps[] = ['sch_settings already has data', 'SKIPPED'];
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
