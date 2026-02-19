#!/bin/shell

file_name=$0
service_name=catalogue

source ./common.sh

sudo_check

app_setup

node_unzip_setup

create_service

cp $Working_dir/mongo.repo /etc/yum.repos.d/mongo.repo

dnf install mongodb-mongosh -y &>> $log_file

INDEX=$(mongosh --host $Mongodb_host --quiet  --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $INDEX -le 0 ]; then
    mongosh --host $Mongodb_host </app/db/master-data.js &>> $log_file
    VALIDATE $? "schema loading"
else
    echo -e "schem is already loaded ... $Y skipping $N" | tee -a $log_file

fi

enable_start $service_name


end_time