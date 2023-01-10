#!/bin/bash

script_location=$(pwd)

LOG=/tmp/roboshop.log

status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[1;32mSUCCESS\e[0m"
  else
    echo -e "\e[1;31mFAILURE\e[0m"
    echo "Refer Log file for more information, LOG - ${LOG}"
    exit 1
  fi
}

print_head(){
  echo -e "\e[1m $1 \e[0m"
}

App_PreReq(){

  print_head "add app user roboshop"
  id roboshop &>>${LOG}
  if [ $? -ne 0];
  then
    useradd roboshop &>>${LOG}
  fi
  status_check

  print_head "create app directory"
  mkdir -p /app &>>${LOG}
  status_check

  print_head "Cleanup Old Content"
    rm -rf /app/* &>>${LOG}
    status_check

  print_head "Download app code"
  curl -L -o /tmp/${Component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${LOG}
  status_check

  print_head "unzip app code"
  cd /app &>>${LOG}
  unzip /tmp/${component}.zip &>>${LOG}
  status_check
}

SystemD_Setup(){

  print_head "setup ${component} service file "
  cp ${script_location}/Files/${component}.service /etc/systemd/system/${component}.service &>>${LOG}
  status_check

  print_head "Daemon reload"
  systemctl daemon-reload &>>${LOG}
  status_check

  print_head "enable ${component} service "
   systemctl enable ${component} &>>${LOG}
  status_check

  print_head "restart ${component} service "
   systemctl restart ${component} &>>${LOG}
  status_check

}

Load_Schema(){
if [${schema_load} == "true"]; then
 if [${schema_type} == "mango"] ; then

  print_head "Copying mongodb repo file"
  cp ${script_location}/Files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
  status_check

  print_head "Install mangodb"
  yum install mongodb-org-shell -y &>>${LOG}
  status_check

  print_head "Load Schema "
   mongo --host mongodb-dev.devops-practice.online < /app/schema/${component}.js &>>${LOG}
  status_check
  fi
  if [ ${schema_type} == "mysql" ]; then

        print_head "Install mysql"
        yum install mysql -y &>>${LOG}
        status_check

        print_head "Load Schema "
         mysql -h mysql-dev.devops-practice.online -uroot -p${root_mysql_password} < /app/schema/${component}.sql
        status_check
  fi
fi
}

nodejs (){

print_head "Setup NodeJS repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "install nodejs"
yum install nodejs -y &>>${LOG}
status_check

App_PreReq

print_head "Download nodejs dependencies"
cd /app &>>${LOG}
npm install &>>${LOG}
status_check

SystemD_Setup

Load_Schema
}

maven() {

  print_head "Install Maven"
  yum install maven -y &>>${LOG}
  status_check

  App_PreReq

  print_head "Build a package"
  mvn clean package  &>>${LOG}
  status_check

  print_head "Copy App file to App Location"
  mv target/${component}-1.0.jar ${component}.jar
  status_check

  SystemD_Setup

  Load_Schema

}

python(){
   print_head "Install Python"
    yum install python36 gcc python3-devel -y &>>${LOG}
    status_check

    App_PreReq

    print_head "Download Dependencies"
    cd /app
    pip3.6 install -r requirements.txt  &>>${LOG}
    status_check

    print_head "Update Passwords in Service File"
    sed -i -e "s/roboshop_rabbitmq_password/${roboshop_rabbitmq_password}/" ${script_location}/Files/${component}.service  &>>${LOG}
    status_check

    SystemD_Setup
}

golang(){

   print_head "Install golang"
      yum install golang -y &>>${LOG}
      status_check

      App_PreReq

      print_head "download dependencies and build software"
      cd /app &>>${LOG}
      go mod init dispatch &>>${LOG}
      go get &>>${LOG}
      go build &>>${LOG}
      status_check

      SystemD_Setup
}