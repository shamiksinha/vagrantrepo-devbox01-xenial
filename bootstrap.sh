#!/usr/bin/env bash
 
#accommodate proxy environments
#export http_proxy=http://proxy.company.com:8080
#export https_proxy=https://proxy.company.com:8080
apt-get -y update
apt-get -y install nginx
debconf-set-selections <<< 'mysql-server mysql-server/root_password password secret'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password secret'
apt-get -y install mysql-server
#mysql_install_db
#mysql_secure_installation
apt-get -y install php-fpm php-mysql
sed -i s/\;cgi\.fix_pathinfo\s*\=\s*1/cgi.fix_pathinfo\=0/ /etc/php/7.0/fpm/php.ini
service php7.0-fpm restart
mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
cp /vagrant/default /etc/nginx/sites-available/default
DIRECTORY="/usr/share/nginx/html"
if [ ! -d $DIRECTORY ]; then
  mkdir $DIRECTORY
fi
echo "<?php phpinfo(); ?>" > /usr/share/nginx/html/info.php
service nginx restart