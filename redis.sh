source common.sh

print_head "Install rmp repo file"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${LOG}
status_check

print_head "Enable redis 6.2"
dnf module enable redis:remi-6.2 -y &>>${LOG}
status_check

print_head "Install redis"
yum install redis -y &>>${LOG}
status_check

print_head "Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/redis.conf"
sed -i -e 's/127.0.0.1/0.0.0.0' /etc/redis.conf &>>${LOG}
status_check

print_head "Enable redis"
systemctl enable redis &>>${LOG}
status_check

print_head "Restart redis"
systemctl restart redis &>>${LOG}
status_check