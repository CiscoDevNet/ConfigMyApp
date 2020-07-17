FROM ubuntu:latest

LABEL name="ConfigMyApp" \
      vendor="AppDynamics" \
      version="${version}" \
      url="https://appdynamics.github.io/ConfigMyApp/" \
      summary="AppDynamics monitoring-as-a-service configuration tool " \
      description="ConfigMyApp automatically configures your AppDynamics application"

RUN apt-get update && \
	apt-get install -y -qq curl && \
    apt-get install -y -qq gawk && \
    apt-get install -y -qq sed && \
    apt-get install -y -qq unzip && \
    apt-get install -y -qq jq && \
	apt-get clean

COPY ./ /opt/configmyapp

WORKDIR /opt/configmyapp

RUN chmod +x ./start.sh; \ 
    chmod +x ./configMyApp.sh; \
    chmod +x ./configBT.sh; \
    ls -ltr

ENTRYPOINT ["./start.sh"]