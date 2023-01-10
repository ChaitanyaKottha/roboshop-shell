source common.sh

print_head "Configuring Nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "Install nodejs"
yum install nodejs -y &>>${LOG}
status_check

print_head "Add application user roboshop"
id=roboshop &>>${LOG}
if [ $? -ne 0 ];
then
  useradd roboshop &>>${LOG}
fi
status_check

print_head "Setup app directory"
mkdir -p /app &>>${LOG}
status_check

print_head "Clean up old content"
rm -rf /tmp/* &>>${LOG}
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
cd ${script_location}/Files/catalogue.services /etc/systemd/system/catalogue.service &>>${LOG}
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

print_head "Copying mongodb repo file"
cp ${script_location}/Files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check


print_head "Install mangodb"
yum install mongodb-org-shell -y &>>${LOG}
status_check

print_head "Load Schema "
 mongo --host mongodb-dev.devops-practice.online < /app/schema/catalogue.js &>>${LOG}
status_check