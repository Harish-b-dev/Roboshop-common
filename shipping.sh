#!/bin/shell

file_name=$0
service_name=shipping

source ./common.sh

sudo_check

app_setup

mvn_unzip_setup

create_service

enable_start $service_name


dnf install mysql -y &>> $log_file
VALIDATE $? "installing mysql"

DB_USER="root"
DB_PASS="RoboShop@1"
SCHEMA_FILE="/app/db/schema.sql"

# 1. Check if a specific database exists (e.g., 'cities')
# Replace 'cities' with the actual database name used in your schema
mysql -h $mysql_host -u$DB_USER -p$DB_PASS -e 'use cities' &>> $log_file

if [ $? -ne 0 ]; then
    echo "Schema not found. Loading schema..."
    mysql -h $mysql_host -u$DB_USER -p$DB_PASS < $SCHEMA_FILE
    VALIDATE $? "Schema loading"

    mysql -h $mysql_host -u$DB_USER -p$DB_PASS < /app/db/app-user.sql
    VALIDATE $? "app-user loading"

    mysql -h $mysql_host -u$DB_USER -p$DB_PASS < /app/db/master-data.sql
    VALIDATE $? "master-data loading"
    
else
    echo -e "Schema already exists. $Y Skipping load$N."
fi

enable_start $service_name

end_time