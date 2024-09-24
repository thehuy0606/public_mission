#!/bin/sh
# https://tothost.vn/kien-thuc/cach-chay-minecraft-server-tren-vps-linux
# https://minecraftvn.net/cach-tao-server-minecraft-va-cac-phan-co-ban-day-du-chi-tiet.t17940/
yum -y update && yum -y upgrade
yum install wget vim screen bzip2 nano net-tools cronie -y 
wget https://download.oracle.com/java/22/latest/jdk-22_linux-x64_bin.deb
sudo dpkg -i jdk-22_linux-x64_bin.deb

mkdir Minecraft
cd Minecraft
wget -O https://piston-data.mojang.com/v1/objects/59353fb40c36d304f2035d51e7d6e6baa98dc05c/server.jar

java -Xmx1024M -Xms1024M -jar server.jar nogui
# Tất cả nội dung của thư mục /minecraft sẽ được liệt kê, bao gồm cả tệp EULA. Mở tệp EULA bằng trình soạn thảo văn bản Nano:
# Trước khi bật Minecraft server, bạn sẽ cần chấp thuận EULA. Đây là một thỏa thuận pháp lý giữa bạn và Mojang về cách bạn sử dụng phần mềm Minecraft. 
nano eula.txt
# Nếu đồng ý với các điều khoản, đổi eula=false thành eula=true và lưu file EULA:

# Nhập lệnh dưới đây (Lưu ý: bạn cần điều chỉnh câu lệnh trên theo đúng phiên bản file jar bạn đã đổi tên):
java -Xmx1024M -Xms1024M -jar server.jar nogui

# Để bắt đầu cấu hình Minecraft server của mình, nhập lệnh sau:
vi server.properties
# Tùy Chỉnh cấu hình tại bước này 

# ần sửa cấu hình tường lửa một chút. Minecraft mặc định sử dụng cổng 25565, nghĩa là bạn sẽ cần thiết lập chuyển tiếp cổng cho 25565
iptables -I INPUT -p tcp --dport 25565 -j ACCEPT

java -Xms3072M -Xmx4096M -jar /root/minecraft2/forge-1.21.1-52.0.10-shim.jar nogui
