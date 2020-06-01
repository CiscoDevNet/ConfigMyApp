FROM jenkinsci/blueocean:latest
USER root
RUN apk add --update jq
COPY docker.conf /etc/init.d/docker
USER jenkins 