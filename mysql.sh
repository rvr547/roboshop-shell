#!/bib/bash
DATE=$(date +%F-%H-%M)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
LOGDIR=/tmp
LOGFILE=$LOGDIR/$0-$DATE.log
USERID=$(id -u)
#USERROBO=$(id roboshop)

if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR: Root access required to install the package $N"
    exit 1
fi

VALIDATE()
{
  if [ $1 -ne 0 ]
then 
    echo -e "$2  ........$R Failure $N"
    exit 1
else
    echo  -e "$2  ......$G Successful $N"
fi  
}

yum module disable mysql -y &>>$LOGFILE

VALIDATE $? " Disabling mysql "

cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>>$LOGFILE

VALIDATE $? " coping mysql.repo  "

yum install mysql-community-server -y &>>$LOGFILE

VALIDATE $? " Installing mysql community server "

systemctl enable mysqld &>>$LOGFILE

VALIDATE $? " Disabling mysql "

systemctl start mysqld &>>$LOGFILE

VALIDATE $? " Starting mysql "

mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOGFILE

VALIDATE $? " resetting default root password "


