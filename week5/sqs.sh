#!/usr/bin/env bash
aws sqs send-message --queue-url ${QUEUE_URL} --message-body "{\"message\": \"test-message\"}"
aws sqs receive-message --queue-url ${QUEUE_URL}
aws sqs purge-queue --queue-url ${QUEUE_URL}
