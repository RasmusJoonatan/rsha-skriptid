#!/bin/bash

apt update
apt upgrade -y

#Apache2 paigaldus
check=$(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c 'ok installed')
if [ $check -eq 1 ]; then
	echo "Apache2 on juba instaleeritud"
	service apache2 start
	service apache2 status
elif [ $check -eq 0 ]; then
	echo "Apache2 instaleerimine"
	apt-get install apache2 -qq > /dev/null
	echo "Apache2 instaleeritud"
fi

#php paigaldus
php=$(dpkg-query -W -f='${Status}' php7.0 2>/dev/null | grep -c 'ok installed')
if [ $php -eq 0 ]; then
	echo "php versioon 7.0 paigaldamine"
	apt-get install php7.0 libapache2-mod-php7.0 php7.0-mysql -qq > /dev/null
	echo "php 7.0 instaleeritud"
elif [ $php -eq 1 ]; then
	echo "php on juba instaleeritud"
	which php
fi

#Mysql serveri paigaldus
Mysql=$(dpkg-query -W -f='${Status}' mysql-server 2>/dev/null | grep -c 'ok installed')
if [ $Mysql -eq 0 ]; then
	echo "Mysql serveri paigaldus koos vajalike lisadega"
	apt-get install mysql-server -qq > /dev/null
	echo "Mysql server on paigaltatud"
	touch $Home/.my.cnf
	echo "[client]" >> $Home/.my.cnf
	echo "host = localhost" >> $Home/.my.cnf
	echo "user = root" >> $Home/.my.cnf
	echo "password = qwerty" >> $Home/.my.cnf
	echo "Konfiguratsiooni fail asub kaustas $Home/.my.cnf"
elif [ $Mysql -eq 1 ]; then
	echo "Mysql server on juba paigaltatud"
	mysql
fi

#Mysql andmebaasi loomine
mysql <<EOF
CREATE DATABASE wordpress;
CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'qwerty';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost';
FLUSH PRIVILEGES;
SHOW DATABASES;
EOF

#phomyadmin paigaldus
PHPMA=$(dpkg-query -W -f='{$Status}' phpmyadmin 2>/dev/null | grep -c 'ok installed')
if [ $PHPMA -eq 0 ]; then
	echo "PHPmyadmin paigaldamine koos vajalike lisadega"
	apt-get install phpmyadmin -y
	echo "PHPmyadmin on paigaltatud"
elif [ $PHPMA -eq 1 ]; then
	echo "PHPmyadmin on juba paigaltatud"
fi

#wordpressi paigaldusskript

echo "Wordpressi paigaldamine"
wget https://wordpress.org/latesst.tar.gz -P /var/www/html/
tar xzf /var/www/html/latest.tar.gz -C /var/www/html
cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
rm -r /var/www/html/latest.tar.gz
perl -pi -e "s/satabase_name_here/wordpress/g" /var/www/html/wordpress/wp-config.php
perl -pi -e "s/username_here/wordpress/g" /var/www/html/wordpress/wp-config.php
perl -pi -e "s/password_here/qwerty/g" /var/www/html/wordpress/wp-config.php
echo "Wordpress on paigaldatud"

#skripti lõpp
