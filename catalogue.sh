#!/bib/bash
DATE=$(date +%F-%H-%M)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
LOGDIR=/tmp
LOGFILE=$LOGDIR/$0-$DATE.log
USERID=$(id -u)
USERROBO=$(id roboshop)
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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE

VALIDATE $? "Setting up npm source "

yum install nodejs -y &>> $LOGFILE

VALIDATE $? " Install nodejs"

if [ $USERROBO -ne 0 ]
then
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "roboshop user creation"
else
    
    echo "Roboshop User already exists"
fi

mkdir /app &>> $LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

VALIDATE $? "downloading catalogue artifact"

cd /app &>> $LOGFILE

VALIDATE $? "Moving to app directoring"

unzip /tmp/catalogue.zip &>> $LOGFILE

VALIDATE $? "Unzip cataloguee"

npm install &>> $LOGFILE

VALIDATE $? "nmp Install"

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE $? "copie catalogue.service  to system"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "daemon-reload"

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "Enable catalogue"

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "Start catalogue"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copie Mongo.repo to yum.repos.d"

yum install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "Install mongodb-org-shell"

mongo --host mongodb.preprv.online </app/schema/catalogue.js &>> $LOGFILE

VALIDATE $? "Loding catalogue data into mongodb"