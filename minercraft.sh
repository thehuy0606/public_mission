#!/bin/sh
yum -y update && yum -y upgrade
yum install wget vim screen bzip2 nano net-tools cronie -y 
yum install openjdk-17-jdk
mkdir –p /Minecraft
cd /Minecraft
wget -O minecraft_server.jar https://piston-data.mojang.com/v1/objects/59353fb40c36d304f2035d51e7d6e6baa98dc05c/server.jar
