---
sort: 19
---

<p><img align="right" width="200" height="75" src="https://user-images.githubusercontent.com/2548160/87821525-e3f6a400-c867-11ea-8f27-edcfe83a6108.png"></p>

# Docker

You can run ConfigMyApp by using either the official docker image or you can build a custom docker image from the source code. 

## ConfigMyApp docker image 

ConfigMyApp images are available from Docker hub and can be downloaded using `docker pull`. For example: 

`docker pull appdynamicscx/configmyapp:latest`

## Build a custom docker image

Alternatively, you may build your own ConfigMyApp image using the following steps: 

1. Clone the <a href="https://github.com/Appdynamics/ConfigMyApp" target="_blank">repository</a>
2. change directory the docker folder
3. Run  `./build.sh <tag_name> <image_name>`  

## Docker run

The `run.sh` script in the docker folder contains 3 examples (standard, BT, and branding) on how to run the configMyApp docker image. 

First, you would need to define your environment variables using the `env.list` file in the docker folder as an example. 

Standard run: 

`docker run --name ConfigMyApp --env-file env.list appdynamicscx/configmyapp:latest` 

### Mount branding volume

To use your company's logo and background images, use the following steps: 

1. Create a folder called `branding`, add both images into the folder.
2. In the `env.list` file, add the following BRANDING environment variables:

```
CMA_USE_BRANDING=true
CMA_BACKGROUND_NAME=<bg_image_name>.<file-extension>
CMA_LOGO_NAME=<logo_image_name>.<file-extension>

```
 3.Mount the `branding` volume in docker run. The docker run command should be executed from the `branding` folder on your host. 

 ```yaml
 docker run -d \
      --name ConfigMyApp
      --mount type=bind,source=$(pwd)/branding,destination=/opt/configmyapp/branding \
      --env-file docker/env.list  appdynamicscx/configmyapp:latest
 ```
Note: Do not use qoutes in the environment variable values, and it's *NOT* best practice to use spaces in the file name. 

### Mount business transaction volume

Use the following steps to automate business transaction configuration using the docker image:

1. Create a folder called `bt_config` 
2. Copy the `configBT.json` file from the project into the `bt_config` folder on your docker host 
3. Make necessary adjustments to the folder depending on your need. Please refer to the <a href="https://appdynamics.github.io/ConfigMyApp/#business-transaction-configuration"> business transaction configuration</a> section for details
4. Mount the `bt_config` volume in docker run. The docker run command should be executed from the `bt_config` folder on your host. 

```yaml
docker run -d \
  --name ConfigMyApp
  --mount type=bind,source=$(pwd)/bt_config,destination=/opt/configmyapp/bt_config \
  appdynamicscx/configmyapp:latest
```

Once your container is up and running, execute `docker ps` to check the container status, then tail the logs: 

`docker logs ConfigMyApp -f`

The output should be similar to this:

```
Checking if API_Gateway business application exist in http://controller-cx.com:8090/controller...

Found API_Gateway business application

Creating Server Visibility Health Rules...Please wait


Creating API_Gateway Health Rules...

done

Processing Dashboard Template.

Applying Database and SIM settings to the dashboard template...
done

Creating dashboard in the controller
*********************************************************************

[TRUNCATED]

```