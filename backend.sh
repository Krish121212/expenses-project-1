#!/bin/bash/

source /home/ec2-user/expenses-project-1/common.sh

check_root_user

echo "please enter DB password:"
read -s "DB_password"

dnf module disable nodejs -y &>>$LOGFILE
Validate $? "diabling deafult nodejs version"

dnf module enable nodejs:20 -y &>>$LOGFILE
Validate $? "enabling nodejs new version "

dnf install nodejs -y &>>$LOGFILE
Validate $? "installing nodejs"

id expense &>>$LOGFILE
    if [ $? != 0 ]
    then
        useradd expense 
        Validate $? "creating expense user"
    else
        echo -e "Expense user already created $Yellow Skipping $Nor" 
    fi

mkdir -p /app &>>$LOGFILE
Validate $? "creating new directory /app"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
Validate $? "Downloading Backend code"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE
Validate $? "Extracting backend code"

npm install &>>$LOGFILE
Validate $? "Installing nodejs dependencies"

cp /home/ec2-user/expenses_project/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
Validate $? "copied backend services"

systemctl daemon-reload &>>$LOGFILE
systemctl start backend &>>$LOGFILE
systemctl enable backend &>>$LOGFILE
Validate $? "Starting and enabling backend"

dnf install mysql -y &>>$LOGFILE
Validate $? "installing mysql client"

mysql -h 172.31.18.28 -uroot -p${DB_password} < /app/schema/backend.sql &>>$LOGFILE
Validate $? "Connecting to DB"

systemctl restart backend &>>$LOGFILE
Validate $? "restarting backend"













