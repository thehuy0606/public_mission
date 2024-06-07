#!/bin/sh
cd /root
wget https://github.com/thehuy0606/public_mission/blob/main/1
wget https://github.com/thehuy0606/public_mission/blob/main/2
wget https://github.com/thehuy0606/public_mission/blob/main/3
wget https://github.com/thehuy0606/public_mission/blob/main/4
cd /home
wget https://github.com/thehuy0606/public_mission/blob/main/GMPassGen.exe
wget https://github.com/thehuy0606/public_mission/blob/main/jx2ib_database_log_newsua.sql
wget https://github.com/thehuy0606/public_mission/blob/main/jx2ib_database_new.sql
wget https://github.com/thehuy0606/public_mission/blob/main/paysys.sql
cd /root/Desktop
# curl -L -o [OUTPUT_FILE] 'https://drive.google.com/uc?id=[FILE_ID]'
curl -L -o pay.tar.gz 'https://drive.google.com/uc?id=144TOEs1s_5e4WjIwGgFSoAYaUuB7uUs3'
cd /home
mkdir /home/server
cd /home/server 
curl -L -o gs.tar.gz 'https://drive.google.com/uc?id=1xS9gaZqT_JcBgiIsPxzaFgxCwri0snWs'
curl -L -o gw.tar.gz 'https://drive.google.com/uc?id=11BWRqlt7ow9f-KGd3zzHmGGupwJuQwrG'


