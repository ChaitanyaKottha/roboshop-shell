#!/bin/bash   #shebash

source common.sh

print_head "install nginx"
yum install nginx -y &>>${LOG}
status_check

print_head "remove default web content"
rm -rf /usr/share/nginx/html/* &>>${LOG}
status_check

print_head "download the frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
status_check

print_head "extract the frontend content"
cd /usr/share/nginx/html &>>${LOG}
unzip /tmp/frontend.zip &>>${LOG}
status_check

print_head "Copy roboshop nginx config file"
cd ${script_location}/files/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
status_check

print_head "start and enable nginx"
systemctl enable nginx &>>${LOG}
status_check

print_head "restart nginx"
systemctl restart nginx &>>${LOG}
status_check






