FROM ubuntu:14.04

RUN apt-get update && apt-get install -y apache2
RUN apt-get install -y php5 php5-common php5-cli php5-mysql php5-curl 
RUN apt-get install -y git

RUN sed -i 's|www/html|www/ca|g' "/etc/apache2/sites-available/000-default.conf"

RUN git clone "https://github.com/collectiveaccess/providence.git" "/var/www/ca/providence"

RUN rm -R '/var/www/html'

COPY 'src/setup.php' '/var/www/ca/providence/'

RUN mkdir '/var/www/ca/providence/media/collectiveaccess'

RUN chmod 777 '/var/www/ca/providence/media/collectiveaccess'

RUN chmod -R 777 '/var/www/ca/providence/app'

RUN chmod 777 '/var/www/ca/providence/vendor/ezyang/htmlpurifier/library/HTMLPurifier/DefinitionCache/Serializer'

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
