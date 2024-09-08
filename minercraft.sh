#!/bin/sh
# https://tothost.vn/kien-thuc/cach-chay-minecraft-server-tren-vps-linux
# https://minecraftvn.net/cach-tao-server-minecraft-va-cac-phan-co-ban-day-du-chi-tiet.t17940/
yum -y update && yum -y upgrade
yum install wget vim screen bzip2 nano net-tools cronie -y 
yum install openjdk-17-jdk
mkdir –p /Minecraft
cd /Minecraft
wget -O minecraft_server.jar https://piston-data.mojang.com/v1/objects/59353fb40c36d304f2035d51e7d6e6baa98dc05c/server.jar

# Trước khi bật Minecraft server, bạn sẽ cần chấp thuận EULA. Đây là một thỏa thuận pháp lý giữa bạn và Mojang về cách bạn sử dụng phần mềm Minecraft. 
# Nhập lệnh dưới đây (Lưu ý: bạn cần điều chỉnh câu lệnh trên theo đúng phiên bản file jar bạn đã đổi tên):
java -Xmx1024M -Xms1024M -jar minecraft_server.jar nogui

# Đến đây, để xác nhận đồng ý với Minecraft EULA, chạy câu lệnh:
ls

# Tất cả nội dung của thư mục /minecraft sẽ được liệt kê, bao gồm cả tệp EULA. Mở tệp EULA bằng trình soạn thảo văn bản Nano:
nano eula.txt
# Nếu đồng ý với các điều khoản, đổi eula=false thành eula=true và lưu file EULA:

# Để bắt đầu cấu hình Minecraft server của mình, nhập lệnh sau:
vi server.properties
