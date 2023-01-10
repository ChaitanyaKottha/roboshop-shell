source common.sh

print_head "Setup NodeJS repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "install nodejs"
yum install nodejs -y &>>${LOG}
status_check

print_head "add app user roboshop"
id roboshop &>>${LOG}
if [ $? -ne 0];
then
  useradd roboshop &>>${LOG}
fi
status_check

print_head ""
mkdir -p /app &>>${LOG}
status_check

print_head "Download app code"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${LOG}
status_check

print_head "unzip app code"
cd /app &>>${LOG}
unzip /tmp/user.zip &>>${LOG}
status_check

print_head "Download dependencies"
cd /app &>>${LOG}
npm install &>>${LOG}
status_check

print_head "setup service file "
cp ${script_location}/Files/user.service /etc/systemd/system/user.service &>>${LOG}
status_check

print_head ""
&>>${LOG}
status_check