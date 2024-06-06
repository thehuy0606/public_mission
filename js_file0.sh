yum install curl -y 


mysql_secure_installation
ln -s /var/lib/mysql/mysql.sock /tmp/mysql.sock
vim /etc/my.cnf
[mysqld]
lower_case_table_names=1
systemctl restart mariadb
systemctl status mariadb
mysql -uroot -p
CREATE DATABASE jx2ib_database;
CREATE DATABASE jx2ib_database_log;
create database paysys;
use jx2ib_database;
source /home/jx2ib_database_new.sql;
use jx2ib_database_log;
source /home/jx2ib_database_log_newsua.sql;
use paysys;
source /root/Desktop/pay/paysys.sql;
GRANT ALL PRIVILEGES ON jx2ib_database.* TO 'root'@'localhost' IDENTIFIED BY 'thuong2020' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON jx2ib_database_log.* TO 'root'@'127.0.0.1' IDENTIFIED BY 'thuong2020' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON paysys.* TO 'root'@'localhost' IDENTIFIED BY 'thuong2020' WITH GRANT OPTION;
FLUSH PRIVILEGES;
exit
