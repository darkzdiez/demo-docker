# docker build -f Dockerfile -t testing:v4 .

FROM ubuntu:24.04
MAINTAINER soporte@osole.es

RUN apt-get update

RUN apt-get -y install curl git nano cron unzip p7zip-full wget htop iputils-ping inetutils-traceroute \
        lsb-release ca-certificates apt-transport-https software-properties-common -y

RUN add-apt-repository ppa:ondrej/php

RUN apt-get -y install apache2 \
        mysql-client postgresql-client \
        php8.3 libapache2-mod-php8.3 php8.3 php8.3-common php8.3-gd php8.3-mysql php8.3-http php8.3-curl php8.3-intl php8.3-xsl php8.3-mbstring \
        php8.3-zip php8.3-bcmath php8.3-common php8.3-soap php8.3-imagick php8.3-pgsql php8.3-interbase php8.3-uuid php8.3-zip php8.3-xml php8.3-bz2 php8.3-sqlite3 php8.3-odbc php8.3-imap \
        php8.3-raphf php8.3-http \
        webp optipng gifsicle jpegoptim \
        fonts-powerline zsh git-core locales language-pack-en gnupg dirmngr vim neovim sqlite3

RUN apt-get update && apt-get -y install cron

RUN /etc/init.d/apache2 stop
RUN a2enmod rewrite

RUN sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/mi-app\/public/g' /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html

COPY hello-cron /etc/cron.d/hello-cron
 
RUN chmod 0644 /etc/cron.d/hello-cron

RUN crontab /etc/cron.d/hello-cron
 
RUN touch /var/log/cron.log

CMD cron && /etc/init.d/apache2 start && tail -f /var/log/apache2/error.log

EXPOSE 80/tcp