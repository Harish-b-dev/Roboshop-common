#!/bin/shell

file_name=$0
service_name=rabbitmq

source ./common.sh

sudo_check

cp $Working_dir/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "copying rammitmq repo"

dnf install rabbitmq-server -y &>> $log_file
VALIDATE $? "Installing ... rabbitmq-server"

enable_start rabbitmq-server

sudo rabbitmqctl authenticate_user roboshop roboshop123 &>> $log_file

if [ $? -ne 0 ]; then
    echo -e "rabbitmq-server user name and password is not changed ... $B changing$Y"
    rabbitmqctl add_user roboshop roboshop123
    VALIDATE $? "rabbitmq-server user name and password update"

    rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
    VALIDATE $? "rabbitmq-server permissions set up"

else
    echo -e "$Y Skipping ... user name, password, permissions$N set up are already updated in rabbitmq-server"

fi

end_time