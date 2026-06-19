FROM php:7.4-cli

# Install system dependencies for PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libcurl4-openssl-dev \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install required PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql gd curl mbstring zip xml

WORKDIR /app
COPY . .

# Make upload/cache/log dirs writable
RUN mkdir -p uploads application/cache application/logs \
    && chmod -R 777 uploads application/cache application/logs

EXPOSE 8080

CMD php -S 0.0.0.0:$PORT router.php
