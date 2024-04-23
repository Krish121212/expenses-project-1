#!/bin/bash/

set -e

err_report() {
    echo "Error on line $1 .. $2"
}

trap 'err_report ${line}  ${command}' ERR

userid=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d '.' -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log
Red="\e[31m"
Green="\e[32m"
Yellow="\e[33m"
Nor="\e[0m"

check_root_user(){
if [ $userid != 0 ]
then
    echo "please run package with super user access: failure"
    exit 1
else
    echo -e "you are super user: $Green SUCCESS $Nor"
fi
}

Validate(){
if [ $1 != 0 ]
then
    echo -e "$2...$Red FAILURE $Nor"
    exit 1
else
    echo -e "$2...$Green SUCCESS $Nor"
fi
}