FROM php:8.2-fpm

# system deps
RUN apt-get update && apt-get install -y \
    git unzip libpq-dev libzip-dev \
    && docker-php-ext-install pdo pdo_pgsql pgsql zip

# install composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# create www-data user permissions
WORKDIR /var/www/html
RUN chown -R www-data:www-data /var/www/html

# expose fpm socket port
EXPOSE 9000
CMD ["php-fpm"]
