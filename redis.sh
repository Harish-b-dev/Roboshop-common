#!/bin/shell

file_name=$0
service_name=redis

source ./common.sh


dnf list installed redis &>> $log_file
if [ $? -ne 0 ]; then
    dnf module disable redis -y &>> $log_file
    dnf module enable redis:7 -y &>> $log_file
    dnf install redis -y &>> $log_file
    VALIDATE $? "redis version 7 ... installation"

else
    echo -e "redis is already installed ... $Y skipping $N" | tee -a $log_file

fi

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
sed -i 's/protected-mode yes/protected-mode no/g' /etc/redis/redis.conf


enable_start redis

end_time