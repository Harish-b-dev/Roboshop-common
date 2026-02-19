#!/bin/shell


echo "Script execution started at $(date +"%d-%m-%Y -- %H:%M:%S")"



user=$(id -u)
logs_folder="/var/log/roboshop"
log_file="$logs_folder/$file_name.log"
command_type=$1
start_time=$(date +%s)
Working_dir="/home/ec2-user/Roboshop-common"
Mongodb_host="mongodb.learndaws88s.online"
mysql_host="mysql.learndaws88s.online"

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


app_setup(){
    id roboshop &>> $log_file
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop 
        VALIDATE $? "adding user"
    else
        echo "Roboshop user already exists"
    fi

    mkdir -p /app 


    curl -o /tmp/$service_name.zip https://roboshop-artifacts.s3.amazonaws.com/$service_name-v3.zip &>> $log_file
    cd /app

}

node_unzip_setup(){
    dnf module disable nodejs -y &>> $log_file
    VALIDATE $? "nodejs disabled"

    dnf module enable nodejs:20 -y &>> $log_file
    VALIDATE $? "nodejs version 20 enabled"

    dnf install nodejs -y&>> $log_file
    VALIDATE $? "nodejs installed"

    rm -rf /app/*

    unzip /tmp/$service_name.zip &>> $log_file

    npm install &>> $log_file
}

mvn_unzip_setup(){
    dnf install maven -y &>> $log_file
    VALIDATE $? "maven installed"

    rm -rf /app/*

    unzip /tmp/shipping.zip &>> $log_file
    
    mvn clean package &>> $log_file
    mv target/shipping-1.0.jar shipping.jar &>> $log_file
    VALIDATE $? "shipping-1.0.jar shipping.jar ... name updated"
}

python_unzip_setup(){
    dnf install python3 gcc python3-devel -y &>> $log_file
    VALIDATE $? "python3 gcc python3-devel installation"

    rm -rf /app/*

    unzip /tmp/payment.zip &>> $log_file

    pip3 install -r requirements.txt &>> $log_file
}

nginx_unzip_setup(){
    rm -rf /usr/share/nginx/html/*

    curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>> $log_file

    cd /usr/share/nginx/html
    unzip /tmp/frontend.zip &>> $log_file
    VALIDATE $? "Nginx page unziped"

    rm -rf /etc/nginx/nginx.conf

    cp $Working_dir/nginx.conf /etc/nginx/nginx.conf
    VALIDATE $? "nginx.conf updated"
}

create_service(){
    cp $Working_dir/$service_name.service /etc/systemd/system/$service_name.service

    systemctl daemon-reload
}

enable_start(){

    systemctl enable $1 &>> $log_file
    VALIDATE $? "enabled ... $1"

    systemctl start $1 &>> $log_file
    VALIDATE $? "started ... $1"

    systemctl restart $1 &>> $log_file
    VALIDATE $? "started ...$1"
}


end_time(){
    end_time=$(date +%s)
    final_time=$(($end_time - $start_time))
    echo "script executed at $final_time"
}