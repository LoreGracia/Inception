if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

cat << EOF > /tmp/db_setup.sql
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
CREATE DATABASE IF NOT EXISTS \${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '\${MYSQL_USER}'@'%' IDENTIFIED BY '\${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \${MYSQL_DATABASE}.* TO '\${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '\${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

/usr/bin/mysqld --user=mysql --bootstrap < /tmp/db_setup.sql
rm -f /tmp/db_setup.sql

exec /usr/bin/mysqld --user=mysql --console --bind-address=0.0.0.0