#!/bib/bash
DATE=$(date +%F-%H-%M)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
LOGDIR=/tmp
LOGFILE=$LOGDIR/$0-$DATE.log
USERID=$(id -u)
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

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copied mongo.repo to yum.repos.d folder"

yum install mongodb-org -y &>> $LOGFILE

VALIDATE $? "MongoDB Installation"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "Enable mongod"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "Start mongod"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "IP replace MongoDb config"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "Restart mongod"
