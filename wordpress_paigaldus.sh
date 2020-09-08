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
