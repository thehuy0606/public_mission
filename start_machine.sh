#!/bin/sh
yum -y update && yum -y upgrade
yum install net-tools wget -y 
yum install screen -y 
yum install bzip2 -y 
yum install nano -y 
yum install ufw -y 
yum install vim -y 
yum install cronie -y 
