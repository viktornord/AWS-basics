#!/bin/bash -xe
yum install -y postgresql
cd /tmp
mkdir scripts
aws s3 cp s3://vurbanas-bucket/scripts ./scripts --recursive
chmod -R 644 scripts
cd scripts
mkdir /root/.aws/
echo $'[default]\nregion = us-east-1' > /root/.aws/config
bash dynamodb-script.sh > dynamo.log
cat rds-script.sql | psql postgres://qwerty:qwerty123456@terraform-20200618185024582800000001.cb3bg3hfcyci.us-east-1.rds.amazonaws.com:5432/postgres > rds.log
