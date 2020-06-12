#!/usr/bin/env bash
aws dynamodb list-tables;
aws dynamodb batch-write-item --request-items "{\"testdb\": [{\"PutRequest\": {\"Item\": {\"id\": {\"N\": \"$((1000 + RANDOM % 9999))\" }, \"username\": {\"S\": \"Viktor\"}}}},{\"PutRequest\": {\"Item\": {\"id\": {\"N\": \"$((1000 + RANDOM % 9999))\" }, \"username\": {\"S\": \"Sara\"}}}}]}";
aws dynamodb scan --table-name testdb --projection-expression "id, username";

