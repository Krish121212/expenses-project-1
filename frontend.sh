#!/bin/bash/

source /home/ec2-user/expenses-project-1/common.sh

check_root_user

dnf install nginx -y &>>$LOGFILE
Validate $? "Installig nginx service"

systemctl enable nginx &>>$LOGFILE
Validate $? "enablig nginx service"

systemctl start nginx &>>$LOGFILE
Validate $? "starting nginx service"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
Validate $? "removing existing content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
Validate $? "downloading html code"

cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$LOGFILE
Validate $? "Extracting frontend code"

cp /home/ec2-user/expenses_project/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
Validate $? "copied frontend services"

systemctl restart nginx &>>$LOGFILE
Validate $? "Restarted nginx services"