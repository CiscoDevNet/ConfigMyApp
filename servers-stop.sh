#!/usr/bin/env bash

# stop Jenkins server
docker container stop $(docker container ls -q --filter name=jenkins*)

# stop Harness delegate
docker container stop $(docker container ls -q --filter name=harness*)

sleep 2

docker ps