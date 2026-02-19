#!/bin/shell

file_name=$0
service_name=nginx

source ./common.sh

sudo_check


#dnf module disable nginx -y &>> $log_file
#dnf module enable nginx:1.24 -y &>> $log_file
dnf module install nginx:1.24 -y &>> $log_file
VALIDATE $? "Nginx version 1.24 ... installation" 

nginx_unzip_setup

enable_start $service_name

end_time