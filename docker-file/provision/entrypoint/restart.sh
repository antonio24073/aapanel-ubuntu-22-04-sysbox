#!/bin/sh

#ini restart aapanel
bt 1

sh /www/server/panel/plugin/pgsql_manager/pgsql.sh start
chown mysql:mysql /www/server/data
/www/server/mysql/scripts/mysql_install_db --user=mysql
/etc/init.d/mysqld start
/etc/init.d/php-fpm-74 start
/etc/init.d/php-fpm-80 start
/etc/init.d/php-fpm-81 start
/etc/init.d/php-fpm-82 start
/etc/init.d/php-fpm-83 start
/etc/init.d/redis start
/etc/init.d/pure-ftpd start
/etc/init.d/nginx restart
/usr/local/lsws/bin/lswsctrl restart
/etc/init.d/httpd restart
/etc/init.d/httpd start
/etc/init.d/memcached restart
systemctl start docker
systemctl start containerd
#end restart aapanel