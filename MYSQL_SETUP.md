# MySQL Setup and Troubleshooting Guide

## Quick Setup Checklist

- [ ] MySQL service is running
- [ ] MySQL user account exists (usually 'root')
- [ ] Database is created for Smart School
- [ ] Database credentials are correct
- [ ] mysqli PHP extension is enabled

## Step 1: Start MySQL Service

### Windows (WAMP)

**Option A: Using WAMP Menu**
1. Right-click WAMP icon in taskbar
2. Hover over "MySQL"
3. Click "Start Service"
4. Wait for green indicator

**Option B: Command Prompt (as Administrator)**
```cmd
net start MySQL80
```

**Option C: Services Management**
1. Press `Win+R`
2. Type `services.msc`
3. Find "MySQL80" (or "MySQL57" for older versions)
4. Right-click → Start

**Check MySQL Status:**
```cmd
sc query MySQL80
```

Should show `STATE: RUNNING`

### Linux/Mac

```bash
# Ubuntu/Debian
sudo systemctl start mysql

# CentOS/RHEL
sudo systemctl start mysqld

# macOS (Homebrew)
brew services start mysql

# Manual start (macOS)
mysql.server start
```

## Step 2: Verify MySQL Connection

### Using Command Line

```cmd
# Windows: Open Command Prompt
cd c:\wamp64\bin\mysql\mysql*

# Connect to MySQL (default, no password)
mysql -u root -p

# If prompted for password, just press Enter
# If successful, you'll see: mysql>

# Type: quit
# Press: Enter
```

### Using phpMyAdmin (Easier)

1. Open browser: `http://localhost/phpmyadmin`
2. You should see login page
3. Username: `root`
4. Password: (leave blank, just click Go)
5. If successful, you're in phpMyAdmin

## Step 3: Create Database

### Using phpMyAdmin

1. Log in to `http://localhost/phpmyadmin`
2. Click "New" in the left panel
3. Enter database name: `school1_db` (or your preference)
4. Keep default settings (utf8_general_ci collation)
5. Click "Create"

### Using Command Line

```sql
mysql -u root -p

-- If you don't have a password, just press Enter
-- Once inside MySQL prompt, type:

CREATE DATABASE school1_db;
SHOW DATABASES;
```

### Using Script

Create a file `create_db.sql`:
```sql
CREATE DATABASE IF NOT EXISTS school1_db;
```

Then run:
```cmd
mysql -u root -p < create_db.sql
```

## Step 4: Verify Database Access

### Test Connection with Python

Create test_mysql.py:
```python
import mysql.connector

try:
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="",  # Empty if no password
        database="school1_db"
    )
    print("✓ Connected successfully!")
    print(f"Connection ID: {conn.connection_id}")
    conn.close()
except Exception as e:
    print(f"✗ Connection failed: {e}")
```

Run:
```cmd
python test_mysql.py
```

### Test Connection with PHP

Create test_mysql.php in web root:
```php
<?php
$hostname = "localhost";
$username = "root";
$password = "";
$database = "school1_db";

$connection = mysqli_connect($hostname, $username, $password, $database);

if (!$connection) {
    echo "✗ Connection failed: " . mysqli_connect_error();
} else {
    echo "✓ Connection successful!";
    echo "<br>MySQL Version: " . mysqli_get_server_info($connection);
    mysqli_close($connection);
}
?>
```

Access: `http://localhost/test_mysql.php`

## Step 5: Smart School Installer

Once MySQL is running and database exists:

1. Visit: `http://localhost/school1/install`
2. **Step 1:** Verify all requirements
3. **Step 2:** Enter MySQL credentials
   - Hostname: `localhost`
   - Database: `school1_db`
   - Username: `root`
   - Password: (leave empty)
4. **Step 3:** Create admin account
5. Installation complete!

## Common MySQL Issues & Solutions

### Issue: "Access denied for user 'root'@'localhost'"

**Cause:** Wrong password

**Solutions:**
1. Default root password is usually empty (blank)
2. Leave password field empty in installer
3. Press Enter if prompted for password in command line

**Reset Root Password:**

```cmd
# Stop MySQL
net stop MySQL80

# Start without password requirement
c:\wamp64\bin\mysql\mysql*\bin\mysqld --skip-grant-tables

# In another command prompt, connect
mysql -u root

# Inside MySQL:
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY 'newpassword';
EXIT;

# Restart MySQL normally
net start MySQL80
```

### Issue: "Can't connect to MySQL server on 'localhost'"

**Cause:** MySQL not running or wrong port

**Solutions:**
1. Check MySQL is running: `sc query MySQL80`
2. Start MySQL service: `net start MySQL80`
3. Check if MySQL is listening on port 3306:
   ```cmd
   netstat -an | find "3306"
   ```
4. If port 3306 is not in use, MySQL isn't running

**Check MySQL Status:**
```cmd
# Check if service exists
sc query MySQL80

# Check if it's running
tasklist | find "mysqld"
```

### Issue: "Unknown database 'school1_db'"

**Cause:** Database not created yet

**Solutions:**
1. Create database using phpMyAdmin (easiest)
2. Or create using command line: `CREATE DATABASE school1_db;`
3. Verify database exists: `SHOW DATABASES;`

### Issue: "Got an error reading communication packets"

**Cause:** Connection interrupted or database too large

**Solutions:**
1. Increase MySQL timeout in installer
2. Check `max_allowed_packet` in MySQL config
3. Try importing database schema manually

**Check max_allowed_packet:**
```sql
SHOW VARIABLES LIKE 'max_allowed_packet';

-- If too small, increase it:
-- Edit c:\wamp64\bin\mysql\mysql*\data\my.ini
-- Find [mysqld] section
-- Add: max_allowed_packet=256M
-- Restart MySQL
```

## MySQL Configuration (my.ini)

Location: `c:\wamp64\bin\mysql\mysql*\data\my.ini`

**Important settings:**

```ini
[mysqld]
# Maximum allowed packet size
max_allowed_packet=256M

# Buffer pool size (for performance)
innodb_buffer_pool_size=256M

# Character set
character_set_server=utf8mb4
collation_server=utf8mb4_unicode_ci

# Connection timeout
wait_timeout=28800
max_connections=1000
```

## Backup & Restore Database

### Backup (Export)

**Using phpMyAdmin:**
1. Select database
2. Go to "Export" tab
3. Click "Go" (SQL format)
4. File downloads as SQL file

**Using Command Line:**
```cmd
mysqldump -u root -p school1_db > backup_school1.sql
```

### Restore (Import)

**Using phpMyAdmin:**
1. Select database
2. Go to "Import" tab
3. Choose SQL file
4. Click "Go"

**Using Command Line:**
```cmd
mysql -u root -p school1_db < backup_school1.sql
```

## Useful MySQL Commands

| Command | Purpose |
|---------|---------|
| `SHOW DATABASES;` | List all databases |
| `USE database_name;` | Select database |
| `SHOW TABLES;` | List tables in current database |
| `DESCRIBE table_name;` | Show table structure |
| `SELECT COUNT(*) FROM table_name;` | Count rows in table |
| `SHOW GRANTS FOR 'root'@'localhost';` | Show user permissions |
| `SHOW VARIABLES LIKE 'max%';` | Show MySQL variables |

## Performance Tuning

### For Development/Testing:
```ini
[mysqld]
max_connections=100
innodb_buffer_pool_size=512M
max_allowed_packet=256M
```

### For Small Production:
```ini
[mysqld]
max_connections=500
innodb_buffer_pool_size=1G
max_allowed_packet=256M
table_cache=400
```

## Security Recommendations

1. **Change root password after installation:**
   ```sql
   ALTER USER 'root'@'localhost' IDENTIFIED BY 'strongpassword';
   ```

2. **Create application database user:**
   ```sql
   CREATE USER 'school1_user'@'localhost' IDENTIFIED BY 'apppassword';
   GRANT ALL ON school1_db.* TO 'school1_user'@'localhost';
   FLUSH PRIVILEGES;
   ```

3. **Remove test database:**
   ```sql
   DROP DATABASE test;
   ```

4. **Disable remote root access:**
   ```sql
   DELETE FROM mysql.user WHERE User='root' AND Host!='localhost';
   FLUSH PRIVILEGES;
   ```

## Monitoring MySQL

### Check running processes:
```sql
SHOW PROCESSLIST;
```

### Check database size:
```sql
SELECT 
  table_schema,
  SUM(data_length + index_length) / 1024 / 1024 AS size_mb
FROM information_schema.tables
GROUP BY table_schema;
```

### Check slow queries:
```sql
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 2;
```

## Get Help

- MySQL Official: https://dev.mysql.com/
- WAMP/phpMyAdmin: http://phpmyadmin.net/
- Smart School: Check application documentation
- Stack Overflow: Tag your question with [mysql]

## After Setup

1. ✓ MySQL running
2. ✓ Database created
3. ✓ Connection verified
4. ✓ Proceed to Smart School installation

