#!/bin/shell

file_name=$0
service_name=cart

source ./common.sh

sudo_check


node_setup

app_setup

node_unzip_setup

enable_start cart

end_time