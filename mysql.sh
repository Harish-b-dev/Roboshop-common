#!/bin/shell

file_name=$0
service_name=mysqld

source ./common.sh

sudo_check

dnf install mysql-server -y &>> $log_file
VALIDATE $? "Mysql server ... installation"

enable_start $service_name

mysql_secure_installation --set-root-pass RoboShop@1

end_time