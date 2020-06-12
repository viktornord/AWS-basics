#!/bin/bash -xe
cd /tmp
aws s3 cp s3://vurbanas-bucket/hello_world.txt hello_world.txt
chmod 644 hello_world.txt
