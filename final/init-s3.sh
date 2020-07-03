#!/usr/bin/env bash
aws s3api create-bucket --bucket vurbanas-bucket --acl private;
aws s3 cp calc-0.0.1-SNAPSHOT.jar s3://vurbanas-bucket/calc-0.0.1-SNAPSHOT.jar;
aws s3 cp persist3-0.0.1-SNAPSHOT.jar s3://vurbanas-bucket/persist3-0.0.1-SNAPSHOT.jar;
