#!/bin/sh
yum -y update && yum -y upgrade
yum install net-tools wget -y 
yum install screen -y 
yum install bzip2 -y 
yum install nano -y 
yum install ufw -y 
yum install vim -y 
yum install cronie -y 

yum install samba-winbind-clients -y
yum groupinstall 'Development Tools' -y
yum install libjpeg-turbo-devel libtiff-devel freetype-devel -y
yum install wget -y 
yum install vim -y 
yum install screen -y 
yum install bzip2 -y 
yum install nano -y 
yum install net-tools -y 
yum -y install glibc.i686
yum -y install zlib.i686
yum -y install libstdc++.i686
yum -y install https://harbottle.gitlab.io/wine32/7/i386/wine32-release.rpm
yum -y install wine.i686
yum -y install mariadb-server
systemctl start mariadb
systemctl enable mariadb
yum -y install epel-release yum-utils httpd
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php73
yum install php php-common php-opcache php-mcrypt php-cli php-gd php-curl php-mysqlnd -y
php -v
cd /var/www/html/
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.0/phpMyAdmin-5.0.0-all-languages.zip
unzip phpMyAdmin-5.0.0-all-languages.zip
mv phpMyAdmin-5.0.0-all-languages thuong
systemctl start httpd
systemctl enable httpd
yum install -y epel-release
yum install -y xrdp
systemctl enable xrdp
systemctl start xrdp
yum groupinstall -y "MATE Desktop"
systemctl stop firewalld
systemctl disable firewalld
localectl set-locale LANG=en_US.UTF-8
reboot
