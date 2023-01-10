source common.sh

print_head "Copying mongodb repo file"
cp ${script_location}/Files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check


print_head "Install mangodb"
yum install mongodb-org -y &>>${LOG}
status_check

print_head "Change 127.0.0.1  to 0.0.0.0 in mongod.conf file"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG}
status_check

print_head "Enable mongodb"
systemctl enable mongod &>>${LOG}
status_check

print_head "restart mongodb"
systemctl restart mongod &>>${LOG}
status_check