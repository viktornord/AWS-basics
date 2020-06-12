#!/bin/bash -xe
cd /tmp
mkdir scripts
aws s3 cp s3://vurbanas-bucket/scripts ./scripts --recursive
chmod -R 644 scripts
