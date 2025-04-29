FROM php:7.2-fpm
# FROM jiangqiao/php-7.2.33-fpm-banban-2021-11:latest
# Install required packages including libsodium
RUN apt-get update && apt-get install -y \
    git gcc make autoconf libc-dev pkg-config libpcre3-dev libargon2-0-dev \
    libsodium-dev \
    && docker-php-source extract \
    # Install Sodium extension
    && docker-php-ext-install sodium \
    # Build Phalcon
    && git clone -b v3.4.5 --depth=1 https://github.com/phalcon/cphalcon.git /tmp/cphalcon \
    && cd /tmp/cphalcon/build \
    && ./install \
    # Register Phalcon extension
    && echo "extension=/usr/local/lib/php/extensions/no-debug-non-zts-20170718/phalcon.so" > /usr/local/etc/php/conf.d/phalcon.ini \
    # Ensure Sodium is loaded
    && echo "extension=sodium.so" > /usr/local/etc/php/conf.d/30-sodium.ini \
    && docker-php-source delete \
    # Cleanup
    && rm -rf /tmp/cphalcon \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
