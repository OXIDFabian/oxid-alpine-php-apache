ARG COMPOSER_VERSION=2.2
ARG ALPINE_VERSION=3.16

FROM composer:"${COMPOSER_VERSION}" as composer
FROM alpine:"${ALPINE_VERSION}"
ARG PHP_VERSION=8
ENV PHP_VERSION "$PHP_VERSION"

# Setup apache and php
RUN apk --no-cache --update \
    add apache2 \
    apache2-utils \
    curl \
    git \
    mysql-client \
    msmtp \
    libmemcached \
    php"${PHP_VERSION}"-common \
    php"${PHP_VERSION}"-apache2 \
    php"${PHP_VERSION}"-bcmath \
    php"${PHP_VERSION}"-curl \
    php"${PHP_VERSION}"-dom \
    php"${PHP_VERSION}"-gd \
    php"${PHP_VERSION}"-iconv \
    php"${PHP_VERSION}"-mbstring \
    php"${PHP_VERSION}"-mysqli \
    php"${PHP_VERSION}"-openssl \
    php"${PHP_VERSION}"-pdo_mysql \
    php"${PHP_VERSION}"-phar \
    php"${PHP_VERSION}"-tokenizer \
    php"${PHP_VERSION}"-xml \
    php"${PHP_VERSION}"-simplexml \
    php"${PHP_VERSION}"-xmlwriter \
    php"${PHP_VERSION}"-zip \
    php"${PHP_VERSION}"-ctype \
    php"${PHP_VERSION}"-session \
    php"${PHP_VERSION}"-fileinfo \
    php"${PHP_VERSION}"-soap \
    && mkdir -p /var/www/oxideshop/source \
    && chown -R apache:apache /var/www/ \
    && \
    ln -sf /usr/bin/php"${PHP_VERSION}" /usr/bin/php \
    && \
    if [ ${PHP_VERSION} = 7 ]; then \
        apk --no-cache --update \
        add php"${PHP_VERSION}"-json; \
    fi

COPY --from=composer /usr/bin/composer /usr/bin/composer

EXPOSE 80

COPY docker-entrypoint.sh /usr/local/bin/docker-php-entrypoint

RUN ["chmod", "+x", "/usr/local/bin/docker-php-entrypoint"]

ENTRYPOINT ["/usr/local/bin/docker-php-entrypoint"]
