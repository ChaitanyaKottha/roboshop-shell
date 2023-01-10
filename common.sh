#!/bin/bash

script_location=$(pwd)

LOG=/tmp/roboshop.log
status_check(){
  if [$? -eq 0] then
    echo -e "\e[1;32mSUCCESS\e[0m"
    else
      echo -e "\e[1;32mFAILURE\e[0m"
      echo "Refer log file for more info , LOG - ${LOG}"
      exit 1
      fi

}

print_head(){
  echo -e "\e[1m $1 \e[0m"
}