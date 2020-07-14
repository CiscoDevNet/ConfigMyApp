# Jenkins 

Jenkins is a free and open source automation server. 
It helps automate the parts of software development related to building, testing, and deploying, facilitating continuous integration and continuous delivery.

## Prerequisite

Verify that you are having Docker Compose installed:

    ```
    docker-compose --version
    ```

## Run Jenkins as Docker Constainer

To start a local Jenkins server navigate to Jenkins folder and start the containers defined in docker-compose.yaml file:

    ```
    cd /integrations/Jenkins
    docker-compose up -d
    ```

In order to show running containers, use the following command:

    ```
    docker ps
    ```

Jenkins is running on localhost:8080 and you can access it in the browser.

Since volumes are mounted, note that all of your data configurations, plugins, pipelines, passwords, etc. will be persisted on the machine where containers are stared from.

For more information about running Jenkins in Docker container refer to the official documentation: https://www.jenkins.io/doc/book/installing/#downloading-and-running-jenkins-in-docker

## Unlock Jenkins

If you are starting the Jenkins container for the first time, in order to check for your password, access the container logs in the following way:

    ```
    docker logs CONTAINER_ID
    ```
    
And copy and paste the password from container to a Jenkins web form input field when prompted.

More details about Unlocking Jenkins can be found here: https://www.jenkins.io/doc/book/installing/#unlocking-jenkins