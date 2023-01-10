source common.sh

print_head "Disable default mysql 8 version"
dnf module disable mysql -y &>>${LOG}
status_check

print_head "Setup repo file for mysql 5.7"
 cp ${script_location}/Files/mysql.repo /etc/yum.repos.d/mysql.repo &>>${LOG}
status_check

print_head "Install mysql"
yum install mysql-community-server -y &>>${LOG}
status_check

print_head "Enable mysql"
 systemctl enable mysqld &>>${LOG}
status_check

print_head "restart mysql"
 systemctl restart mysqld &>>${LOG}
status_check

print_head "Change default root password"
mysql_secure_installation --set-root-pass RoboShop@1 &>>${LOG}
status_check

print_head "check if new pwd is working"
mysql -uroot -pRoboShop@1 &>>${LOG}
status_check