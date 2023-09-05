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

yum install maven -y &>>$LOGFILE

VALIDATE $? "Installing Maven"

useradd roboshop &>>$LOGFILE

mkdir /app

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>$LOGFILE

VALIDATE $? "Downloding Shipping artifact"

cd /app &>>$LOGFILE

VALIDATE $? "Moving to App directory"

unzip /tmp/shipping.zip &>>$LOGFILE

VALIDATE $? "Unzipping shipping artifact files"

mvn clean package &>>$LOGFILE

VALIDATE $? "Clean package"

mv target/shipping-1.0.jar shipping.jar &>>$LOGFILE

VALIDATE $? "Renaming Shiiping Jar file"

cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>>$LOGFILE

VALIDATE $? " Copying shipping.service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "daemon-reload"

systemctl enable shipping &>>$LOGFILE

VALIDATE $? "Enabling shipping"

systemctl start shipping &>>$LOGFILE

VALIDATE $? "starting shipping"

yum install mysql -y &>>$LOGFILE

VALIDATE $? "Installing mysql"

mysql -h mongodb.preprv.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>$LOGFILE

VALIDATE $? "Loding data"

systemctl restart shipping &>>$LOGFILE

VALIDATE $? "restart shipping"

