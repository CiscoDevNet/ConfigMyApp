#!/bin/bash -e

sudo docker pull harness/delegate:latest

sudo docker run -d --restart unless-stopped --hostname=$(hostname -f) \
-e ACCOUNT_ID=YOUR_ACCOUNT_ID_HERE \
-e ACCOUNT_SECRET=YOUR_ACCOUNT_SECRET_HERE \
-e MANAGER_HOST_AND_PORT=https://app.harness.io/gratis \
-e WATCHER_STORAGE_URL=https://app.harness.io/public/free/freemium/watchers \
-e WATCHER_CHECK_LOCATION=current.version \
-e REMOTE_WATCHER_URL_CDN=https://app.harness.io/public/shared/watchers/builds \
-e DELEGATE_STORAGE_URL=https://app.harness.io \
-e DELEGATE_CHECK_LOCATION=delegatefree.txt \
-e DELEGATE_NAME=cma-docker-delegate \
-e DELEGATE_PROFILE=YOUR_DELEGATE_PROFILE_HERE \
-e DEPLOY_MODE=KUBERNETES \
-e PROXY_HOST= \
-e PROXY_PORT= \
-e PROXY_SCHEME= \
-e PROXY_USER= \
-e PROXY_PASSWORD= \
-e NO_PROXY= \
-e PROXY_MANAGER=true \
-e POLL_FOR_TASKS=false \
-e HELM_DESIRED_VERSION= \
-e CF_PLUGIN_HOME= \
-e USE_CDN=true \
-e CDN_URL=https://app.harness.io \
-e JRE_VERSION=1.8.0_242 \
-e HELM3_PATH= \
-e HELM_PATH= \
harness/delegate:latest
