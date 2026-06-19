# Smart School - Installation & Troubleshooting Guide

Welcome! This document will help you get Smart School up and running on your local machine.

## 📋 Table of Contents

1. [Quick Start (5 minutes)](#quick-start)
2. [Detailed Setup Steps](#detailed-setup)
3. [Troubleshooting Issues](#troubleshooting)
4. [Additional Resources](#additional-resources)

---

## Quick Start

### ✅ What You Need

- WAMP/LAMP/MAMP installed (Apache + MySQL + PHP)
- PHP 5.6+ (7.x or 8.x recommended)
- MySQL 5.5+
- Browser (Chrome, Firefox, Edge, Safari)

### ⚡ 5-Minute Setup

1. **Start Services:**
   - Right-click WAMP icon → MySQL → Start Service
   - Right-click WAMP icon → Apache → Start Service
   - Wait for green indicators

2. **Create Database:**
   - Open http://localhost/phpmyadmin
   - Click "New"
   - Type: `school1_db`
   - Click "Create"

3. **Run Installer:**
   - Open http://localhost/school1/install
   - Click through 3 steps
   - Use credentials: `root` / (no password)
   - Create admin account

4. **Login:**
   - Go to http://localhost/school1/
   - Use admin email and password

**Done!** ✓

---

## Detailed Setup

### Step 1: Verify Your Environment

**Check System Requirements:**
- Visit: http://localhost/school1/diagnose.php
- All items should have ✓ checkmarks
- Fix any ✗ items before proceeding

**What to look for:**
- ✓ PHP 5.6+ (shows version)
- ✓ mysqli extension enabled
- ✓ gd extension enabled
- ✓ curl extension enabled
- ✓ mbstring extension enabled
- ✓ zip extension enabled
- ✓ File permissions are writable

### Step 2: Configure Apache

**Enable URL Rewriting:**
1. See: [APACHE_SETUP.md](APACHE_SETUP.md)
2. Enable `mod_rewrite` module
3. Set `AllowOverride All`
4. Restart Apache

**Quick Test:**
```
http://localhost/school1/           ✓ Works
http://localhost/school1/dashboard  ✓ Works (no 404)
```

### Step 3: Configure MySQL

**Start MySQL:**
1. See: [MYSQL_SETUP.md](MYSQL_SETUP.md)
2. Run `net start MySQL80` (Windows)
3. Or use WAMP menu → MySQL → Start Service

**Create Database:**
1. phpMyAdmin: http://localhost/phpmyadmin
2. Click "New"
3. Name: `school1_db`
4. Collation: utf8_general_ci
5. Click "Create"

### Step 4: Run Installation

1. Visit: http://localhost/school1/install
2. **Step 1 - Requirements Check:**
   - Verify all items show green
   - If issues: See [Troubleshooting](#troubleshooting)
   - Click "Proceed"

3. **Step 2 - Database Setup:**
   - Hostname: `localhost`
   - Database: `school1_db`
   - Username: `root`
   - Password: (leave empty)
   - Click "Proceed"

4. **Step 3 - Admin Setup:**
   - Email: Your email
   - Password: Create strong password
   - Confirm: Repeat password
   - Click "Install"

5. **Success!**
   - Note admin credentials
   - Delete `/install` folder (for security)

### Step 5: First Login

1. Go to: http://localhost/school1/
2. Click "Login"
3. Email: (your admin email)
4. Password: (your admin password)
5. Configure school settings in admin panel

---

## Troubleshooting

### 🔴 Issue: White Screen on /install

**Symptoms:** Page shows nothing or error

**Solutions:**

1. **Check errors in browser:**
   - Right-click → Inspect
   - Go to Console tab
   - Look for error messages

2. **Enable PHP error reporting:**
   - Already configured in updated index.php
   - Errors should display automatically

3. **Check PHP extensions:**
   - Visit: http://localhost/school1/diagnose.php
   - Look for red ✗ marks
   - See [Fix PHP Extensions](#fix-php-extensions)

4. **Check server error log:**
   - Windows: `c:\wamp64\logs\apache_error.log`
   - Linux: `/var/log/apache2/error.log`
   - Mac: `/var/log/apache2/error.log`

---

### 🔴 Issue: Database Connection Failed

**Error:** "Access denied" or "Can't connect to MySQL"

**Cause:** MySQL not running or wrong credentials

**Solutions:**

1. **Verify MySQL is running:**
   ```cmd
   # Windows
   net start MySQL80
   
   # If error, check status:
   sc query MySQL80
   ```

2. **Test connection:**
   - Visit: http://localhost/phpmyadmin
   - If it loads, MySQL is running
   - Username: `root`
   - Password: (leave empty)

3. **Create database if missing:**
   - In phpMyAdmin → Click "New"
   - Type: `school1_db`
   - Click "Create"

4. **Check database name:**
   - In installer, must match exactly: `school1_db`
   - Case matters!

5. **For "Access denied" errors:**
   - See: [MYSQL_SETUP.md - Access denied issue](MYSQL_SETUP.md#issue-access-denied-for-user-rootlocalhost)

---

### 🔴 Issue: "File not writable" Error

**Error:** Config files or temp folder not writable

**Cause:** Missing write permissions

**Solutions:**

#### Windows (WAMP) - GUI Method:
1. Right-click folder → Properties
2. Security tab → Edit
3. Select your username
4. Check "Full Control"
5. Apply → OK

#### Windows - Command Prompt:
```cmd
cd c:\wamp64\www\school1

# Give write permissions
icacls "application\config" /grant:r "%username%":F /t
icacls "temp" /grant:r "%username%":F /t
icacls "uploads" /grant:r "%username%":F /t
```

#### Linux/Mac - Terminal:
```bash
cd /var/www/school1

# Give write permissions
sudo chmod -R 755 application/config
sudo chmod -R 755 temp
sudo chmod -R 755 uploads

# Or if running as user:
chmod -R 777 application/config
chmod -R 777 temp
chmod -R 777 uploads
```

---

### 🔴 Issue: 404 Errors / URL Rewriting Not Working

**Symptoms:** Getting 404 errors, URLs show `index.php`

**Cause:** mod_rewrite not enabled or .htaccess not working

**Solutions:**

1. **Enable mod_rewrite:**
   - See: [APACHE_SETUP.md](APACHE_SETUP.md)
   - Find: `#LoadModule rewrite_module modules/mod_rewrite.so`
   - Remove `#`: `LoadModule rewrite_module modules/mod_rewrite.so`

2. **Set AllowOverride:**
   - In `httpd.conf`, find directory section
   - Change to: `AllowOverride All`

3. **Verify .htaccess exists:**
   ```
   c:\wamp64\www\school1\.htaccess
   ```

4. **Restart Apache:**
   ```cmd
   net stop Apache2.4
   net start Apache2.4
   ```

5. **Test URL rewriting:**
   - Visit: http://localhost/school1/
   - Should work without 404

---

### 🟡 Issue: Slow Installation / Timeout

**Symptoms:** Installation takes forever or times out

**Solutions:**

1. **Increase timeouts (already set in index.php):**
   - max_execution_time: 300 seconds
   - memory_limit: 128M

2. **Check PHP settings:**
   - Edit: `c:\wamp64\bin\php\php*\php.ini`
   - Look for:
     ```ini
     max_execution_time = 300
     memory_limit = 128M
     upload_max_filesize = 128M
     ```

3. **Increase MySQL timeout:**
   - Edit: `c:\wamp64\bin\mysql\mysql*\data\my.ini`
   - Under `[mysqld]`, add:
     ```ini
     wait_timeout = 28800
     net_read_timeout = 30
     net_write_timeout = 30
     ```

4. **Restart services:**
   - Restart Apache and MySQL

---

## Fix PHP Extensions

**If you see missing extensions in diagnose.php:**

### Windows (WAMP)

1. Find your PHP version:
   - Right-click WAMP → PHP → Version
   - Note version (e.g., 7.4.26)

2. Edit php.ini:
   - `c:\wamp64\bin\php\php7.*\php.ini` (match your version)

3. Find these lines (use Ctrl+F):
   ```ini
   ;extension=php_mysqli.dll
   ;extension=php_gd2.dll
   ;extension=php_curl.dll
   ;extension=php_mbstring.dll
   ;extension=php_zip.dll
   ```

4. Remove the `;` at start of each line:
   ```ini
   extension=php_mysqli.dll
   extension=php_gd2.dll
   extension=php_curl.dll
   extension=php_mbstring.dll
   extension=php_zip.dll
   ```

5. Save file

6. Restart Apache:
   - Right-click WAMP → Apache → Restart Service

7. Verify:
   - Visit: http://localhost/school1/diagnose.php
   - Extensions should now show ✓

### Linux/Debian/Ubuntu

```bash
sudo apt-get update
sudo apt-get install php-mysqli php-gd php-curl php-mbstring php-zip

# Restart Apache
sudo systemctl restart apache2
```

### Linux/CentOS/RHEL

```bash
sudo yum update
sudo yum install php-mysqli php-gd php-curl php-mbstring php-zip

# Restart Apache
sudo systemctl restart httpd
```

---

## Additional Resources

### Documentation Files (in application root):

- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Comprehensive setup guide
- **[APACHE_SETUP.md](APACHE_SETUP.md)** - Apache & mod_rewrite configuration
- **[MYSQL_SETUP.md](MYSQL_SETUP.md)** - MySQL setup and troubleshooting

### Diagnostic Tools:

- **[diagnose.php](diagnose.php)** - System diagnostics and MySQL test
  - Access: http://localhost/school1/diagnose.php
  - Shows all system info and errors
  - Can test MySQL connection

### Online Resources:

- CodeIgniter: https://codeigniter.com/
- MySQL: https://dev.mysql.com/
- Apache: https://httpd.apache.org/
- PHP: https://www.php.net/

---

## Security Checklist

After successful installation:

- [ ] Delete or rename `/application/controllers/install/` folder
- [ ] Change admin password to something strong
- [ ] Configure HTTPS (SSL certificate)
- [ ] Set `ENVIRONMENT = 'production'` in index.php
- [ ] Disable error display for production
- [ ] Back up database regularly
- [ ] Update Smart School when updates available

---

## Common Paths

| Item | Path |
|------|------|
| Apache config | `c:\wamp64\apache24\conf\httpd.conf` |
| PHP config | `c:\wamp64\bin\php\php*\php.ini` |
| MySQL config | `c:\wamp64\bin\mysql\mysql*\data\my.ini` |
| App config | `c:\wamp64\www\school1\application\config\` |
| Database backup | `c:\wamp64\www\school1\backup\database_backup\` |
| Logs - Apache | `c:\wamp64\logs\apache_error.log` |
| Logs - MySQL | `c:\wamp64\logs\mysql_error.log` |
| Logs - PHP | `c:\wamp64\logs\php_error.log` |

---

## Still Having Issues?

### Step 1: Run Diagnostics
- Visit: http://localhost/school1/diagnose.php
- Screenshot all errors
- Note all missing items

### Step 2: Check Logs
- Apache: `c:\wamp64\logs\apache_error.log`
- MySQL: `c:\wamp64\logs\mysql_error.log`
- PHP: `c:\wamp64\logs\php_error.log`

### Step 3: Check Browser Console
- Press F12 in browser
- Go to Console tab
- Look for error messages

### Step 4: Search Issues
- Search the error message online
- Include "Smart School" or "CodeIgniter" in search
- Add your OS (Windows WAMP, Linux, etc.)

### Step 5: Get Help
- Check documentation files above
- Contact application support
- Check application GitHub issues

---

## Quick Commands Reference

```cmd
# Start/Stop Apache
net start Apache2.4
net stop Apache2.4

# Start/Stop MySQL
net start MySQL80
net stop MySQL80

# Check if service is running
sc query Apache2.4
sc query MySQL80

# Give folder write permissions
icacls "folder_path" /grant:r "%username%":F /t

# Test Apache config
c:\wamp64\apache24\bin\httpd -t

# View MySQL processes
mysql -u root -p -e "SHOW PROCESSLIST;"
```

---

## Installation Complete! 🎉

**Next steps:**
1. ✓ Log in to Smart School
2. ✓ Configure school settings
3. ✓ Import initial data
4. ✓ Set up users and roles
5. ✓ Test all features

**Enjoy using Smart School!**

For questions or issues, refer to the documentation files above or contact support.

"# lms" 
"#lms"
