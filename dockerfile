# Use the official PHP 8.2 Apache base image
FROM php:8.2-apache

# Remove default apache conf
RUN rm /etc/apache2/sites-available/000-default.conf

# Install Dependencies
RUN apt-get update && \
    apt-get install -y libicu-dev unzip && \
    docker-php-ext-install intl && \
    docker-php-ext-install mysqli pdo pdo_mysql && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ENV COMPOSER_ALLOW_SUPERUSER 1

WORKDIR /var/www/webform
COPY . /var/www/webform/
# Copy configurations 
COPY ci/php.ini /usr/local/etc/php/php.ini
COPY ci/webform.conf /etc/apache2/sites-available/webform.conf
COPY ci/config.php app/Config/config.php
COPY ci/Database.php app/Config/Database.php
# Install dependencies
RUN composer install 
# Change Permission
RUN chown -R www-data:www-data /var/www/* 
# Restart Apache services
RUN a2enmod rewrite && a2ensite webform && service apache2 restart

EXPOSE 80
CMD ["apache2-foreground"]