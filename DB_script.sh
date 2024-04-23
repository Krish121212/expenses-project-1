#!/bin/bash/

source /home/ec2-user/expenses-project-1/common.sh

check_root_user

echo "please enter DB password:"
read -s "DB_password"

dnf install mysql-server -y &>>$LOGFILE
#Validate $? "Installing mysql server"

systemctl enable mysqld &>>$LOGFILE
#Validate $? "enabling mysql"

systemctl start mysqld &>>$LOGFILE
#Validate $? "starting mysql"

mysql -h 172.31.29.2 -uroot -p${DB_password} -e "show databases" &>>$LOGFILE
    if [ $? != 0 ]
    then
        mysql_secure_installation --set-root-pass ${DB_password} &>>$LOGFILE
        #Validate $? "password is set for mysql: $Green SUCCESS $Nor"
    else       
        echo -e "password is already set for mysql DB $Yellow Skipping $Nor"    
    fi