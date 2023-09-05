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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$LOGFILE

VALIDATE $? "Downloading rabit mq"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOGFILE


VALIDATE $? "Downloading rabit mq server"

yum install rabbitmq-server -y &>>$LOGFILE


VALIDATE $? "Installing rabit mq server"

systemctl enable rabbitmq-server &>>$LOGFILE


VALIDATE $? "Enabling rabit mq"

systemctl start rabbitmq-server &>>$LOGFILE


VALIDATE $? "Starting rabit mq"

rabbitmqctl add_user roboshop roboshop123 &>>$LOGFILE


VALIDATE $? "Adding user roboshop"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGFILE


VALIDATE $? "chnaging user permissions"