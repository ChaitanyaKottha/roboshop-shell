#!/bin/bash   #shebash

# install nginx
yum install nginx -y

#start and enable nginx

systemctl enable nginx
sytemctl restart nginx



