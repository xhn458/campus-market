FROM php:8.4-apache

RUN docker-php-ext-install pdo_mysql \
    && a2enmod rewrite \
    && sed -ri 's!Listen 80!Listen 10000!' /etc/apache2/ports.conf \
    && sed -ri 's!<VirtualHost \*:80>!<VirtualHost *:10000>!' /etc/apache2/sites-available/000-default.conf \
    && sed -ri 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf \
    && sed -ri 's!AllowOverride None!AllowOverride All!g' /etc/apache2/apache2.conf

WORKDIR /var/www/html
COPY . .

RUN chown -R www-data:www-data /var/www/html

EXPOSE 10000
