source common.sh

print_head "Setup Nodejs"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "Install nodejs"
yum install nodejs -y &>>${LOG}
status_check

print_head "Add user roboshop"
useradd roboshop &>>${LOG}
status_check

print_head "Setup app directory"
mkdir /app &>>${LOG}
status_check

print_head "Download app code to tmp"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check

cd /app &>>${LOG}

print_head "unzip and copy app code to created app directory"
unzip /tmp/catalogue.zip &>>${LOG}
status_check

cd /app &>>${LOG}

print_head "download dependencies"
npm install &>>${LOG}
status_check

print_head "setup systemd catalogue service"
cd ${script_location}/Files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
status_check

print_head "daemon reload "
systemctl daemon-reload &>>${LOG}
status_check

print_head "enable catalogue "
 systemctl enable catalogue &>>${LOG}
status_check

print_head "restart catalogue "
 systemctl restart catalogue &>>${LOG}
status_check

print_head "Install mongodb-client "
labauto mongodb-client &>>${LOG}
status_check

print_head "Load Schema "
 mongo --host mongodb-dev.devops-practice.online < /app/schema/catalogue.js &>>${LOG}
status_check