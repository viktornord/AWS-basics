#!/usr/bin/env bash
aws sns publish --topic-arn ${SNS_TOPIC_ARN} --message 'Hello world!'
