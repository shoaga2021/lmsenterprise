FROM php:7.4-fpm-alpine

# ── System packages ────────────────────────────────────────────────────────────
# gettext  → envsubst for runtime PORT substitution in nginx template
# supervisor → manages both php-fpm and nginx in one container
RUN apk add --no-cache \
    nginx \
    supervisor \
    gettext \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    libzip-dev \
    libxml2-dev \
    oniguruma-dev \
    curl-dev \
    unzip \
    curl

# ── PHP extensions ─────────────────────────────────────────────────────────────
RUN docker-php-ext-configure gd --with-jpeg \
 && docker-php-ext-install -j$(nproc) \
    mysqli pdo pdo_mysql gd curl mbstring zip xml opcache exif

# ── OPcache (warm bytecode cache) ─────────────────────────────────────────────
RUN { \
    echo 'opcache.enable=1'; \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=10000'; \
    echo 'opcache.revalidate_freq=60'; \
    echo 'opcache.fast_shutdown=1'; \
} > /usr/local/etc/php/conf.d/opcache.ini

# ── PHP upload / execution limits ─────────────────────────────────────────────
RUN { \
    echo 'upload_max_filesize=64M'; \
    echo 'post_max_size=64M'; \
    echo 'max_execution_time=300'; \
    echo 'memory_limit=256M'; \
} > /usr/local/etc/php/conf.d/app-limits.ini

# ── Composer (copied from official image) ─────────────────────────────────────
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# ── Runtime config files ───────────────────────────────────────────────────────
COPY docker/nginx.conf.template /etc/nginx/templates/default.conf.template
COPY docker/supervisord.conf    /etc/supervisord.conf
COPY docker/php-fpm.conf        /usr/local/etc/php-fpm.d/zz-app.conf

# ── Application ────────────────────────────────────────────────────────────────
WORKDIR /app
COPY . .

# Install Composer dependencies (aws-sdk-php for R2 storage).
# --no-dev keeps the image lean; --optimize-autoloader speeds up class lookup.
RUN composer install --no-dev --no-interaction --optimize-autoloader

# ── Writable directories ───────────────────────────────────────────────────────
RUN mkdir -p uploads application/cache application/logs \
 && chown -R www-data:www-data /app \
 && chmod -R 775 uploads application/cache application/logs

EXPOSE 8080

# ── Startup ────────────────────────────────────────────────────────────────────
# envsubst rewrites the nginx template with Railway's $PORT, then supervisord
# keeps both php-fpm and nginx alive. Single-quoted '$PORT' ensures only that
# variable is substituted; nginx's own $uri, $query_string, etc. are untouched.
CMD ["sh", "-c", \
    "envsubst '$PORT' < /etc/nginx/templates/default.conf.template > /etc/nginx/nginx.conf && exec /usr/bin/supervisord -c /etc/supervisord.conf"]
