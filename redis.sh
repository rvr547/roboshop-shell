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

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE

VALIDATE $? "Installing Redis Repo"

yum module enable redis:remi-6.2 -y &>>$LOGFILE

VALIDATE $? "Enabling Redis Repo 6.2 version"

yum install redis -y &>>$LOGFILE

VALIDATE $? "Installing Repo 6.2 version"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf /etc/redis/redis.conf &>>$LOGFILE

VALIDATE $? "Allowing remote connection to redis"

systemctl enable redis &>>$LOGFILE

VALIDATE $? "Enabling Redis "

systemctl start redis &>>$LOGFILE

VALIDATE $? "Starting Redis"