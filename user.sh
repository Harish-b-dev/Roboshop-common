#!/bin/shell


file_name=$0
service_name=user

source ./common.sh

sudo_check


node_setup

app_setup

enable_start $service_name

end_time