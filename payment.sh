#!/bin/shell

file_name=$0
service_name=payment

source ./common.sh

sudo_check

app_setup

python_unzip_setup

create_service

enable_start $service_name

end_time