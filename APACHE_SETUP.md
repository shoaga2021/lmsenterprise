# Apache Configuration Guide for Smart School

## Quick Checklist

- [ ] mod_rewrite is enabled
- [ ] AllowOverride is set to "All"
- [ ] .htaccess file exists and is correct
- [ ] Apache has been restarted after changes

## Step 1: Enable mod_rewrite Module

### On Windows (WAMP)

1. **Locate Apache config file:**
   ```
   c:\wamp64\apache24\conf\httpd.conf
   ```

2. **Open with text editor (Notepad++ recommended)**

3. **Find the line (usually around line 161):**
   ```apache
   #LoadModule rewrite_module modules/mod_rewrite.so
   ```

4. **Remove the `#` to uncomment:**
   ```apache
   LoadModule rewrite_module modules/mod_rewrite.so
   ```

5. **Save the file**

### On Linux/Mac

For Ubuntu/Debian:
```bash
sudo a2enmod rewrite
```

For CentOS/RHEL:
```bash
sudo yum install mod_rewrite
```

Then enable:
```bash
sudo a2enmod rewrite
```

## Step 2: Configure VirtualHost or Directory

### WAMP Configuration (httpd.conf)

Find the directory section for your document root:

```apache
# WAMP Default
<Directory "c:/wamp64/www">
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>
```

**Key points:**
- `AllowOverride All` - This allows .htaccess to override settings
- `FollowSymLinks` - Allows symbolic links (needed for some mod_rewrite)
- `Require all granted` - Permits access to the directory

### If not present, add it:

```apache
<Directory "c:/wamp64/www">
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>
```

## Step 3: Verify .htaccess File

**File location:** `c:\wamp64\www\school1\.htaccess`

**Content should be:**
```apache
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ index.php?/$1 [L]
</IfModule>
```

**Explanation:**
- `RewriteEngine On` - Enables rewrite engine
- `RewriteCond %{REQUEST_FILENAME} !-f` - Don't rewrite if file exists
- `RewriteCond %{REQUEST_FILENAME} !-d` - Don't rewrite if directory exists
- `RewriteRule ^(.*)$ index.php?/$1 [L]` - Route all requests through index.php

## Step 4: Restart Apache

### Windows (WAMP)

**Option A: Using WAMP Menu**
1. Right-click WAMP icon in taskbar
2. Hover over "Apache" → Click "Restart Service"
3. Wait for confirmation

**Option B: Command Prompt (as Administrator)**
```cmd
net stop Apache2.4
net start Apache2.4
```

**Option C: Services.msc**
1. Press `Win+R`
2. Type `services.msc`
3. Find "Apache2.4"
4. Right-click → Restart

### Linux/Mac

```bash
# Ubuntu/Debian
sudo systemctl restart apache2

# CentOS/RHEL
sudo systemctl restart httpd

# macOS
sudo apachectl restart
```

## Step 5: Test URL Rewriting

1. **Navigate to:** `http://localhost/school1/`
   - Should load installation or dashboard

2. **Check if URL rewriting works:**
   - Look for URLs without `index.php`
   - Example: `http://localhost/school1/dashboard` (not `/school1/index.php/dashboard`)

3. **If you see 404 errors:**
   - mod_rewrite is not working
   - Check Apache error log: `c:\wamp64\logs\apache_error.log`
   - Verify steps above

## Troubleshooting

### Issue: 404 Not Found on all pages except home

**Possible causes:**
1. mod_rewrite not enabled
2. .htaccess not being read
3. AllowOverride not set to All
4. Apache not restarted

**Solutions:**
```cmd
# 1. Check if module is loaded
# Windows: Search httpd.conf for "LoadModule rewrite_module"

# 2. Check Apache error log
type c:\wamp64\logs\apache_error.log

# 3. Test Apache configuration syntax
c:\wamp64\apache24\bin\httpd -t

# 4. Check if .htaccess exists
dir c:\wamp64\www\school1\.htaccess

# 5. Verify file permissions
icacls c:\wamp64\www\school1\.htaccess /T
```

### Issue: .htaccess is not being read

Check if `.htaccess` exists and is readable:

```bash
# On Linux/Mac
ls -la /var/www/html/school1/.htaccess

# Windows (Command Prompt)
dir c:\wamp64\www\school1\.htaccess
```

If missing, the file was likely filtered. Check Apache `httpd.conf` for:
```apache
# Make sure this is NOT present (or commented out)
# <FilesMatch "\.htaccess$">
#     Deny from all
# </FilesMatch>
```

### Issue: Module is enabled but still getting 404

Check Apache error log for clues:
```cmd
type c:\wamp64\logs\apache_error.log | find "rewrite"
```

Look for messages like:
- `mod_rewrite not enabled` - Enable the module
- `Rewrite engine not initialized` - Check if module loaded
- `Rule reference to parent directory "step" in non-matching CondPattern` - Syntax error

### Issue: Changes not taking effect

Make sure you:
1. Saved the httpd.conf file
2. Restarted Apache service
3. Cleared browser cache (Ctrl+Shift+Delete)
4. Are testing the correct URL

## Verify Apache Configuration

To check Apache configuration syntax:

```cmd
# Windows
c:\wamp64\apache24\bin\httpd -t

# Linux/Mac
httpd -t
# or
apache2ctl configtest
```

You should see:
```
Syntax OK
```

If you see errors, fix them before restarting Apache.

## Common Apache Directives

| Directive | Purpose |
|-----------|---------|
| `LoadModule` | Load a module |
| `AllowOverride` | Allow .htaccess overrides |
| `RewriteEngine` | Enable URL rewriting |
| `RewriteCond` | Add condition to rule |
| `RewriteRule` | Define rewrite rule |
| `Options` | Set directory options |
| `Require` | Access control |
| `DocumentRoot` | Server's root directory |

## Additional Resources

- Apache Rewrite Guide: https://httpd.apache.org/docs/current/mod/mod_rewrite.html
- WAMP Documentation: http://wampserver.com/
- CodeIgniter .htaccess: https://codeigniter.com/userguide3/general/urls.html

## After Fixing

1. Test all pages work without 404 errors
2. Verify URLs are clean (no `index.php` in URL)
3. Check both admin and user-facing pages
4. Clear browser cache and test again
5. Proceed with Smart School installation

