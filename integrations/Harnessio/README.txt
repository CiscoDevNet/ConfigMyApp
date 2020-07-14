
Be sure you have docker installed.

_________________________________________________________________

Option 1: Using Docker run

   cd harness-delegate-docker

Edit launch-harness-delegate.sh to set proxy settings or to enter a delegate description.

Install the Harness Delegate by executing launch-harness-delegate.sh.

Option 2: Using Docker-compose

   cd harness-delegate-docker-compose

Edit harness-variables.env to set your account and other details.

Start the Harness delegate by executing docker-compose up

_________________________________________________________________

Get container IDs:

   docker ps

See startup logs:

   docker logs -f <container-id>

Run a shell in a container:

   docker container exec -it <container-id> bash

