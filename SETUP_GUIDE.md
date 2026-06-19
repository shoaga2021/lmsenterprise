# Smart School Installation Setup Guide

## Quick Start

### 1. Prerequisites Check
Before running the installer, verify you have:
- **PHP 5.6+** (PHP 7.x or 8.x recommended)
- **MySQL 5.5+** with a user account
- **Apache with mod_rewrite enabled**
- Required PHP Extensions: mysqli, gd, curl, mbstring, zip

### 2. Set File Permissions (Windows WAMP)

#### Option A: Using File Explorer (Recommended for Windows)
1. Navigate to `c:\wamp64\www\school1\`
2. Right-click each folder below → Properties → Security → Edit
3. Select your user → Full Control → Apply → OK

**Folders to set permissions:**
- `application/config/`
- `temp/`
- `uploads/`

#### Option B: Using Command Prompt (Admin)
```cmd
cd c:\wamp64\www\school1
icacls "application\config" /grant:r "%username%":F /t /c
icacls "temp" /grant:r "%username%":F /t /c
icacls "uploads" /grant:r "%username%":F /t /c
```

### 3. Enable mod_rewrite in Apache

Edit `c:\wamp64\apache24\conf\httpd.conf`:
1. Find the line: `#LoadModule rewrite_module modules/mod_rewrite.so`
2. Remove the `#` to uncomment it
3. Save and restart Apache (WAMP: right-click → Apache → Restart Service)

### 4. Configure MySQL Database

**Option A: Using phpMyAdmin**
1. Open `http://localhost/phpmyadmin`
2. Click "New"
3. Enter Database name: `school1_db` (or your choice)
4. Click "Create"
5. Note the name for the installer

**Option B: Using MySQL Command Line**
```sql
CREATE DATABASE school1_db;
```

### 5. Start Installation

1. Open browser: `http://localhost/school1/install`
2. Follow the 3-step installation wizard:
   - **Step 1:** Verify all requirements pass (green checkmarks)
   - **Step 2:** Enter database credentials
   - **Step 3:** Create admin account

### 6. Access Application

After successful installation:
- **URL:** `http://localhost/school1/`
- **Admin Login:** Use email and password you created in Step 3

---

## Troubleshooting

### White Screen / No Output on `/install`

**Solution 1: Enable PHP Error Reporting**
1. The installer now automatically shows PHP errors during installation
2. Check the browser console and page source for error messages
3. Check PHP error log: `c:\wamp64\logs\php_error.log`

**Solution 2: Verify PHP Installation**
```cmd
php -v
php -m | find "mysqli"
php -m | find "gd"
php -m | find "curl"
php -m | find "mbstring"
```

**Solution 3: Enable PHP Extensions in php.ini**
1. Open `c:\wamp64\bin\php\php*\php.ini`
2. Uncomment these lines (remove `;`):
```ini
extension=php_mysqli.dll
extension=php_gd2.dll
extension=php_curl.dll
extension=php_mbstring.dll
extension=php_zip.dll
```
3. Restart Apache

---

### Database Connection Failed

**Error: "Access denied for user 'root'@'localhost'"**
- Wrong MySQL password
- Default password is usually empty (blank)
- Check if MySQL user 'root' exists
- Use phpMyAdmin to verify credentials

**Error: "Can't connect to MySQL server on 'localhost'"**
- MySQL service is not running
- WAMP: Right-click taskbar → MySQL → Start Service
- Verify MySQL is listening on port 3306
- Check Windows Firewall isn't blocking MySQL

**Error: "Unknown database 'school1_db'"**
- Database doesn't exist yet (create it first)
- Wrong database name in installer
- Use phpMyAdmin or command line to create database

---

### "File not writable" Error

#### On Windows (WAMP):

**Using File Properties:**
1. Right-click folder → Properties
2. Go to Security tab
3. Click Edit
4. Select your username
5. Check "Full Control"
6. Click Apply → OK

**Using icacls (Command Prompt as Admin):**
```cmd
cd c:\wamp64\www\school1
icacls "application\config" /grant:r "%username%":F /t
icacls "temp" /grant:r "%username%":F /t
icacls "uploads" /grant:r "%username%":F /t
```

**Verify Permissions:**
```cmd
icacls "application\config"
icacls "temp"
icacls "uploads"
```

You should see your username with `(F)` (Full Control) or `(M)` (Modify).

---

### URL Rewriting Not Working (404 Errors)

#### Step 1: Verify `.htaccess` Exists
- Check: `c:\wamp64\www\school1\.htaccess`
- Content should be:
```apache
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ index.php?/$1 [L]
</IfModule>
```

#### Step 2: Enable mod_rewrite
1. Edit: `c:\wamp64\apache24\conf\httpd.conf`
2. Find: `#LoadModule rewrite_module modules/mod_rewrite.so`
3. Remove the `#` to uncomment
4. Restart Apache

#### Step 3: Verify AllowOverride
In `c:\wamp64\apache24\conf\httpd.conf`, find your document root section:
```apache
<Directory "c:/wamp64/www">
    AllowOverride All
    Require all granted
</Directory>
```

If not there, add it.

#### Step 4: Restart Apache
- WAMP: Right-click taskbar → Apache → Restart Service
- Or: `net stop Apache2.4` then `net start Apache2.4`

**Test URL Rewriting:**
- Visit: `http://localhost/school1/welcome`
- Should NOT show 404 error (if page exists)

---

### PHP Extensions Missing

**Check What's Enabled:**
Create a test file `c:\wamp64\www\school1\phpinfo.php`:
```php
<?php phpinfo(); ?>
```
Visit: `http://localhost/school1/phpinfo.php` and search for extension names.

**Enable Extension in php.ini:**

Find your PHP version's php.ini:
- For PHP 7.x: `c:\wamp64\bin\php\php7.*\php.ini`
- For PHP 8.x: `c:\wamp64\bin\php\php8.*\php.ini`

Uncomment these lines:
```ini
; Find and uncomment these (remove the ;)
extension=php_mysqli.dll
extension=php_gd2.dll
extension=php_curl.dll
extension=php_mbstring.dll
extension=php_zip.dll
```

Then restart Apache.

---

### Installation Stuck or Slow

**Solution:**
- Increase PHP timeout in `index.php` (already set to 300 seconds)
- Increase memory limit (already set to 128M)
- Check MySQL error log: `c:\wamp64\logs\mysql_error.log`
- Verify no firewall blocking MySQL/Apache

---

## After Installation Complete

### Secure Installation
1. Delete the installer folder: `application/controllers/install/`
2. Or rename it to make it inaccessible
3. Change admin password in application settings
4. Back up your database

### Configure Application
1. Log in with admin credentials
2. Go to Settings to configure:
   - School name
   - School address
   - Academic year
   - Email/SMS settings
   - Fee structure
   - Etc.

---

## WAMP Service Management

Start services:
```cmd
net start Apache2.4
net start MySQL80
```

Stop services:
```cmd
net stop Apache2.4
net stop MySQL80
```

Check status:
```cmd
sc query Apache2.4
sc query MySQL80
```

---

## Additional Help

- **WAMP Website:** http://wampserver.com/
- **CodeIgniter Docs:** https://codeigniter.com/userguide3/
- **MySQL Docs:** https://dev.mysql.com/doc/
- **Apache Docs:** https://httpd.apache.org/docs/

