#!/usr/bin/env bash

prep: run Jenkins:

cd integrations/Jenkins/
dc up

run harness delegate - & check UI

1.
./start.sh -c http://controller-2060nosshco-o3wdq4ip.appd-cx.com --controller-port=8090 --application-name=API_Gateway --username=appd --password=appd --include-sim --include-database --database-name=ConfigMyApp  --overwrite-health-rules --no-configure-bt

2. Jenkins - same scenario
go to console output

2.2 Harness 

3. BT only run
./start.sh -c http://controller-2060nosshco-o3wdq4ip.appd-cx.com -a API_Gateway -u appd -p appd --bt-only

4. Branding
./start.sh -c http://controller-2060nosshco-o3wdq4ip.appd-cx.com -a API_Gateway -u appd -p appd --use-branding --logo-name="logo-white.png" --background-name="appd-bg.jpg"





