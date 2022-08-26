ARG COMPOSER_VERSION=2.2
ARG ALPINE_VERSION=3.16

FROM composer:"${COMPOSER_VERSION}" as composer
FROM alpine:"${ALPINE_VERSION}"
ARG PHP_VERSION=8
ARG PHP_PACKAGE_VERSION=8.0.20-r0
ARG CURL_PACKAGE_VERSION=7.83.1-r1
ARG GIT_PACKAGE_VERSION=2.36.1-r0
ENV PHP_VERSION "$PHP_VERSION"
# Setup apache and php
RUN apk --no-cache --update \
    add apache2=2.4.54-r0 \
    apache2-utils=2.4.54-r0 \
    curl="${CURL_PACKAGE_VERSION}" \
    git="${GIT_PACKAGE_VERSION}" \
    mysql-client=10.6.9-r0 \
    php"${PHP_VERSION}"-common="${PHP_PACKAGE_VERSION}" \
    php"${PHP_VERSION}"-apache2="${PHP_PACKAGE_VERSION}" \
    php"${PHP_VERSION}"-bcmath="${PHP_PACKAGE_VERSION}" \
    php"${PHP_VERSION}"-curl="${PHP_PACKAGE_VERSION}" \
    php"${PHP_VERSION}"-dom="${PHP_PACKAGE_VERSION}" \
    php"${PHP_VERSION}"-gd="${PHP_PACKAGE_VERSION}" \
    php"${PHP_VERSION}"-iconv="${PHP_PACKAGE_VERSION}" \
    php"${PHP_VERSION}"-mbstring="${PHP_PACKAGE_VERSION}" \
    php"${PHP_VERSION}"-mysqli="${PHP_PACKAGE_VERSION}" \
    php"${PHP_VERSION}"-openssl="${PHP_PACKAGE_VERSION}" \
    php"${PHP_VERSION}"-pdo_mysql="${PHP_PACKAGE_VERSION}" \
    php"${PHP_VERSION}"-phar="${PHP_PACKAGE_VERSION}" \
    php"${PHP_VERSION}"-tokenizer="${PHP_PACKAGE_VERSION}" \
    php"${PHP_VERSION}"-xml="${PHP_PACKAGE_VERSION}" \
    php"${PHP_VERSION}"-xmlwriter="${PHP_PACKAGE_VERSION}" \
    php"${PHP_VERSION}"-zip="${PHP_PACKAGE_VERSION}" \
    php"${PHP_VERSION}"-ctype="${PHP_PACKAGE_VERSION}" \
    php"${PHP_VERSION}"-session="${PHP_PACKAGE_VERSION}" \
    && mkdir -p /var/www/oxideshop/source \
    && chown -R apache:apache /var/www/ \
    && \
    ln -sf /usr/bin/php"${PHP_VERSION}" /usr/bin/php \
    && \
    if [ ${PHP_VERSION} = 7 ]; then \
        apk --no-cache --update \
        add php"${PHP_VERSION}"-json="${PHP_PACKAGE_VERSION}"; \
    fi

COPY --from=composer /usr/bin/composer /usr/bin/composer

EXPOSE 80

COPY docker-entrypoint.sh /usr/local/bin/docker-php-entrypoint

RUN ["chmod", "+x", "/usr/local/bin/docker-php-entrypoint"]

ENTRYPOINT ["/usr/local/bin/docker-php-entrypoint"]
