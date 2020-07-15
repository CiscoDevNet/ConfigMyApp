#!/usr/bin/env bash

# start Jenkins server
cd integrations/Jenkins

docker-compose up -d

# start Harness delegate

cd ../Harnessio/harness-delegate-docker-compose

docker-compose up -d

sleep 2

docker ps