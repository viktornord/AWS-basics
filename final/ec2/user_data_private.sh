#!/bin/bash -xe
mkdir /root/.aws/
echo $'[default]\nregion = us-east-1' > /root/.aws/config
aws s3 cp s3://viktor-bucket/persist3-0.0.1-SNAPSHOT.jar /home/ec2-user
yum install -y java-1.8.0-openjdk
