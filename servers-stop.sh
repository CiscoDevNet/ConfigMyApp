#!/usr/bin/env bash

# stop Jenkins server
cd integrations/Jenkins

docker-compose down

# stop Harness delegate

cd ../Harnessio/harness-delegate-docker-compose

docker-compose down

sleep 2

docker ps