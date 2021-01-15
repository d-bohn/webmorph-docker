FROM php:7-apache

LABEL maintainer="Daniel Albohn <d.albohn@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive
ENV MYSQL_ROOT_PASSWORD=password

RUN mkdir /opt/assets

# Install LAMP

RUN mkdir -p /usr/share/man/man1 && \
    apt-get update && \
    apt-get -y install -qq -y \
    build-essential software-properties-common && \
    apt-add-repository 'deb http://security.debian.org/debian-security stretch/updates main' && \
    apt-get update && \
    apt-get -y install -qq -y \
    git wget sudo \
    openjdk-8-jre \
    openjdk-8-jdk \
    # mysql-server
    mariadb-server 

RUN cd /var/www/html && \
    git clone https://github.com/d-bohn/webmorph

# Follow directions from webmorph github

RUN echo '127.0.0.1 webmorph.test' >> /etc/hosts

ADD ./assets/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN mkdir -p /private/var/log/apache2 && \
    chmod 777 /private/var/log/apache2 && \
    touch /private/var/log/apache2/webmorph-error_log && \
    touch /private/var/log/apache2/webmorph-access_log

# Change some apache2 parms

RUN a2enmod proxy && \
    a2enmod proxy_http && \
    a2enmod proxy_balancer && \
    a2enmod lbmethod_byrequests && \
    a2enmod proxy_ajp  && \
    a2enmod rewrite  && \
    a2enmod deflate  && \
    a2enmod headers  && \
    a2enmod proxy_connect  && \
    a2enmod proxy_html  && \
    a2enmod php7 && \
    service apache2 restart

RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

RUN a2dissite 000-default && \
    a2ensite 000-default && \
    service apache2 restart

# RUN echo 'LoadModule php7_module /usr/lib/apache2/modules/libphp7.1.so' >> /usr/local/apache2/conf/httpd.conf && \
#     service apache2 restart
ADD ./assets/psychomorph_sql_setup.sql /opt/assets/psychomorph_sql_setup.sql

RUN chown -R mysql:mysql /var/lib/mysql && \
    /etc/init.d/mysql start && \
    # /bin/bash -c "mysqld_safe --skip-grant-tables &" && \
    # sleep 5 && \
    mysql -u root < /opt/assets/psychomorph_sql_setup.sql

RUN mkdir /opt/tomcat && \
    cd /opt/tomcat  && \
    wget https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.99/bin/apache-tomcat-7.0.99.tar.gz && \
    tar xvzf apache-tomcat-7.0.99.tar.gz && \
    rm apache-tomcat-7.0.99.tar.gz

RUN ln -s /opt/tomcat/apache-tomcat-7.0.99 /usr/local/tomcat && \
    chmod +x /usr/local/tomcat/bin/*.sh

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV CATALINA_HOME=/opt/tomcat/apache-tomcat-7.0.99
ENV TOMCAT_HOME=/usr/local/tomcat
ENV IMAGE_FOLDER="/opt/assets/webmorph_images"

ADD ./assets/tomcat-users.xml $TOMCAT_HOME/conf/

# RUN groupadd -r _www && useradd -r -g _www _www

RUN mkdir $IMAGE_FOLDER && \
    # chown tomcat7 $IMAGE_FOLDER && \
    chown www-data $IMAGE_FOLDER && \
    chmod 777 $IMAGE_FOLDER && \
    chgrp -R www-data /var/www/html && \
    find /var/www/html -type d -exec chmod g+rx {} + && \
    find /var/www/html -type f -exec chmod g+r {} + && \
    chown -R www-data /var/www/html/ && \
    # chmod -R 777 /var/www/html/ && \
    chmod -R 711 /var/www/html/ && \
    find /var/www/html -type d -exec chmod g+s {} +


ADD ./assets/start_mysqld.sh /start_mysqld.sh
ADD ./assets/start_tomcat.sh /start_tomcat.sh

# ADD ./assets/webmorph_startup.sh /opt/assets/webmorph_startup.sh
# CMD ["/opt/assets/webmorph_startup.sh"]

RUN chmod 755 /*.sh

RUN apt-get -y install supervisor && \
  mkdir -p /var/log/supervisor && \
  mkdir -p /etc/supervisor/conf.d

# supervisor base configuration
ADD assets/supervisor.conf /etc/supervisor.conf

EXPOSE 80 8080 9001
# default command
CMD ["supervisord", "-c", "/etc/supervisor.conf"]
