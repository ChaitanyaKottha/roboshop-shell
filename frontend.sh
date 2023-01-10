#!/bin/bash   #shebash

# install nginx
yum install nginx -y

# remove default web content
rm -rf /usr/share/nginx/html/*

#download the frontend content
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

#extract the frontend content
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

#Copy roboshop nginx config file

cd ${script_location}/files/roboshop.conf /etc/nginx/default.d/roboshop.conf

#start and enable nginx
systemctl enable nginx

# restart nginx
systemctl restart nginx







