#!/bin/bash   #shebash

source common.sh

# install nginx
yum install nginx -y &>>${LOG}

# remove default web content
rm -rf /usr/share/nginx/html/* &>>${LOG}

#download the frontend content
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}

#extract the frontend content
cd /usr/share/nginx/html &>>${LOG}
unzip /tmp/frontend.zip &>>${LOG}

#Copy roboshop nginx config file

cd ${script_location}/files/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}

#start and enable nginx
systemctl enable nginx &>>${LOG}

# restart nginx
systemctl restart nginx &>>${LOG}







