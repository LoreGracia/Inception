cd /var/www/html

if [ ! -f "wp-config.php" ]; then
    wp core download --allow-root
    wp config create --allow-root --dbname=\${MYSQL_DATABASE} --dbuser=\${MYSQL_USER} --dbpass=\${MYSQL_PASSWORD} --dbhost=mariadb:3306
    wp core install --allow-root --url=\${DOMAIN_NAME} --title="Inception" --admin_user=\${WP_ADMIN_USER} --admin_password=\${WP_ADMIN_PWD} --admin_email=\${WP_ADMIN_EMAIL}
    
    wp user create --allow-root \${WP_USER} \${WP_USER_EMAIL} --user_pass=\${WP_USER_PWD} --role=author
fi

mkdir -p /run/hphp

exec /usr/sbin/hhp-fpm82 -F
