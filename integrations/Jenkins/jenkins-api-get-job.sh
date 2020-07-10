#!/usr/bin/env bash

# To export Jenkins Job:
user="admin"
pass="admin"
pipeline="config-my-app-pipeline"
host="localhost:8080"

echo $(curl -X GET "http://$user:$pass@$host/job/$pipeline/config.xml")