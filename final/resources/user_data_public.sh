#!/bin/bash -xe
mkdir /home/ec2-user/.aws/
echo $'[default]\nregion = us-east-1' > /home/ec2-user/.aws/config
aws s3 cp s3://vurbanas-bucket/calc-0.0.1-SNAPSHOT.jar /home/ec2-user
yum install -y java-1.8.0-openjdk
java -jar /home/ec2-user/calc-0.0.1-SNAPSHOT.jar
