#!/bin/shell


file_name=$0
service_name=user

source ./common.sh

sudo_check

app_setup

node_unzip_setup

create_service

enable_start $service_name

end_time