# step 1 : batch update and upgrade
yum install curl -y 
curl https://raw.githubusercontent.com/thehuy0606/public_mission/main/js_file1.sh | bash 
# then reboot and relogin


# step 2 : Thiết lập môi trường đồ họa sử dụng phiên bản MATE desktop environment
curl https://raw.githubusercontent.com/thehuy0606/public_mission/main/js_file2.sh | bash 
# then reboot and relogin 

# step 3 : Download các file cần thiết
curl https://raw.githubusercontent.com/thehuy0606/public_mission/main/js_file3.sh | bash 

# step 4 : Thực thi lệnh và setup database SQL
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
source /home/paysys.sql;

GRANT ALL PRIVILEGES ON jx2ib_database.* TO 'root'@'localhost' IDENTIFIED BY 'Thehuy@1994' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON jx2ib_database_log.* TO 'root'@'127.0.0.1' IDENTIFIED BY 'Thehuy@1994' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON paysys.* TO 'root'@'localhost' IDENTIFIED BY 'Thehuy@1994' WITH GRANT OPTION;
FLUSH PRIVILEGES;
exit
