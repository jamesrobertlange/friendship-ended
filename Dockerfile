# Use official PHP image with Apache
FROM php:8.2-apache

# Install ImageMagick and required dependencies
RUN apt-get update && apt-get install -y \
    libmagickwand-dev \
    imagemagick \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Install PHP imagick extension
RUN pecl install imagick \
    && docker-php-ext-enable imagick

# Enable Apache mod_rewrite (if needed for future enhancements)
RUN a2enmod rewrite

# Create tmp directory for file uploads with proper permissions
RUN mkdir -p /var/www/html/tmp && \
    chown -R www-data:www-data /var/www/html/tmp && \
    chmod -R 755 /var/www/html/tmp

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . /var/www/html/

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache in foreground
CMD ["apache2-foreground"]
