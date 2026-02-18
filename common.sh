#!/bin/shell


echo "Script execution started at $(date +"%d-%m-%Y -- %H:%M:%S")"



user=$(id -u)
logs_folder="/var/log/roboshop"
log_file="$logs_folder/$file_name.log"
command_type=$1
start_time=$(date +%s)
Working_dir="/home/ec2-user/Roboshop-common"
Mongodb_host="mongodb.learndaws88s.online"

#set -e
#trap 'echo "there is an error at $LINENO, command :: $BASH_COMMAND"' ERR

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

echo -e " script execution started now ... $B $command_type $N"

sudo mkdir -p $logs_folder

sudo_check(){
    if [ $user -ne 0 ]; then 
        echo -e  "You need $Y sudo access $N to install packages." | tee -a $log_file
        exit 1

    fi
}


VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$(date +"%d-%m-%Y -- %H:%M:%S") | $R $2 $N ... failure " | tee -a $log_file
        exit 1
    else
        echo -e "$(date +"%d-%m-%Y -- %H:%M:%S") | $G $2 $N ... success" | tee -a $log_file
    fi
}

enable_start(){

    systemctl enable $1 &>> $log_file
    VALIDATE $? "enabled ... mongodb"

    systemctl start $1 &>> $log_file
    VALIDATE $? "started ... mongodb"

    systemctl restart $1 &>> $log_file
    VALIDATE $? "started ... mongodb"
}


end_time(){
    end_time=$(date +%s)
    final_time=$(($end_time - $start_time))
    echo "script executed at $final_time"
}