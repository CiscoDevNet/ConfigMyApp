# Harness.io 

Harness is a Continuous Delivery as a Service enterprise platform for automation of application and micro-service deployments.

The Harness Delegate is a service you run in your local network or VPC to connect your artefact servers, and your infrastructure, collaboration, and verification providers, with the Harness Manager.

## Prerequisite

Be sure you have docker installed.

## Start Harness.io delegate

### Option 1: Using Docker run
   ```
   cd harness-delegate-docker
   ```
Edit launch-harness-delegate.sh to set proxy settings or to enter a delegate description.

Install the Harness Delegate by executing launch-harness-delegate.sh.

### Option 2: Using Docker-compose

Note: Every time container is restarted new delegate will register in the Harness.io UI, as the container gets new local IP address.
   ```
   cd harness-delegate-docker-compose
   ```
Edit harness-variables.env to set your account and other details.

Start the Harness delegate by executing docker-compose up

## Check delegate

Get container IDs:
   ```
   docker ps
   ```
See startup logs:
   ```
   docker logs -f <container-id>
   ```
Run a shell in a container:
   ```
   docker container exec -it <container-id> bash
   ```
In the Harness.io UI delegate appears as active, and you can access it at Setup/Delegates section

