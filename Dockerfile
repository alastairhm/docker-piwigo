FROM debian:wheezy

MAINTAINER Alastair Montgomery <alastair@montgomery.me.uk>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

RUN apt-get update \
     && apt-get dist-upgrade -y \
     && apt-get install -y \
        apache2 \
        dcraw \
        ffmpeg \
        imagemagick \
        libapache2-mod-php5 \
        mediainfo \
        php5-ffmpeg \
        php5-gd \
        php5-mysql \
        unzip \
        wget \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget -q -O piwigo.zip http://piwigo.org/download/dlcounter.php?code=latest && \
    unzip piwigo.zip && \
    rm /var/www/* -rf && \
    mv piwigo/* /var/www && \
    rm -r piwigo*

ADD php.ini /etc/php5/apache2/php.ini

RUN mkdir /template
RUN mv /var/www/galleries /template/
RUN mv /var/www/themes /template/
RUN mv /var/www/plugins /template/
RUN mv /var/www/local /template/


RUN mkdir -p /var/www/_data/i
RUN chown -R www-data:www-data /var/www

VOLUME ["/var/www/galleries", "/var/www/themes", "/var/www/plugins", "/var/www/local", "/var/www/_data/i"]

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh
EXPOSE 80 

