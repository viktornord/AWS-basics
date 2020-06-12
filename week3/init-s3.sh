#!/usr/bin/env bash
aws s3api create-bucket --bucket vurbanas-bucket --acl private;
aws s3 cp scripts s3://vurbanas-bucket/scripts --recursive;
