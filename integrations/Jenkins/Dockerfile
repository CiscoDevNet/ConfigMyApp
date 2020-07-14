FROM jenkinsci/blueocean:latest
USER root
# install dependencies
RUN apk add --update jq; \
    chmod -R 777 /var
# copy docker configuration
COPY docker.conf /etc/init.d/docker
# good practice to not run as root
USER jenkins 