#!/bin/shell


file_name=$0

source ./common.sh

sudo_check


cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "mongodb repo updated" &>> $log_file

dnf install mongodb-org -y &>> $log_file
VALIDATE $? "Installing ... mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf

enable_start 