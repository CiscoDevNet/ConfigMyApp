---
sort: 3
---

# Prerequisites

 The following requirements must be met to run ConfigMyApp:

 1. It's only supported on Linux/Unix and macOS. Tested on Ubuntu, CentOS and MacOS
 2. `jq` must be installed on your machine
 3. `awk` must be installed on the machine
 4. `sed` must be installed on the machine

If you are unable to install any of the above components on your machine, we recommend that you use the <a href="https://appdynamics.github.io/ConfigMyApp/integrations/2-docker.html"> `docker image` </a> instead.

Please do not proceed if any of the above aforementioned prerequisites are not met.

## Service account

A local service account should be created in your controller with the following privileges:

1. Create health rules in all business applications
2. Create dashboards
3. Create business transactions
4. Create Database health rules  
5. View Database collector
6. Create SIM health rules  

*****Single Sign-On user will not work*****
