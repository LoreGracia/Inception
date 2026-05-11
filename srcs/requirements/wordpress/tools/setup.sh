MYSQL_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PWD=$(cat /run/secrets/wp_admin_password)
WP_USER_PWD=$(cat /run/secrets/wp_user_password)

until mariadb-admin ping -h"mariadb" --silent; do
    echo "Waiting for MariaDB..."
    sleep 2
done

cd /var/www/html

if [ ! -f "wp-config.php" ]; then
    wp core download --allow-root
    wp config create --allow-root --dbname=${MYSQL_DATABASE} --dbuser=${MYSQL_USER} --dbpass=${MYSQL_PASSWORD} --dbhost=mariadb:3306
    wp core install --allow-root --url=${DOMAIN_NAME} --title="Inception" --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PWD} --admin_email=${WP_ADMIN_EMAIL}
    
    wp user create --allow-root ${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PWD} --role=author
fi

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

exec /usr/sbin/php-fpm83 -F
