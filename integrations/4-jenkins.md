---
sort: 4
---

# Jenkins

Jenkins is a free and open-source automation server. It helps automate the parts of software development related to building, testing, and deploying, facilitating continuous integration and continuous delivery.

## Running for the first time - setup

If you are running Jenkins for the first time, you need to set up a job with the steps below. If you already specified the job, jump to the next chapter to <a href="https://appdynamics.github.io/ConfigMyApp/integrations/4-jenkins.html#run-jenkins-job">run the Jenkins job</a>, otherwise proceed to the next section.

### Plugins

If you installed recommended packages you may already have GitHub plugin, if you do not then navigate to "Manage Jenkins" and choose "Manage Plugins", search for "git plugin", and click on "Install without restart". You should be seeing GitHub plugin installed:

<img width="1406" alt="Jenkins_plugin" src="https://user-images.githubusercontent.com/23483887/87814360-7fcde300-c85b-11ea-8875-c38ae77d2b70.png">

You may also use the <a href="https://www.jenkins.io/doc/pipeline/steps/workflow-multibranch" target="_blank"> mulitbranch pipeline plugin </a>. 

## Create Jenkins Job

### Multibranch pipleline Job 

We recommend that you include ConfigMyApp into your existing Jenkins pipeline by adding a new stage, usually the last stage before the cleanup task.  

We have created a <a href="https://github.com/Appdynamics/ConfigMyApp/blob/master/integrations/Jenkins/Jenkinsfile" target="_blank"> `Jenkinsfile` </a> that can you easily adapt to suit your multi-stage CI/CD pipelines. The commands in the `Jenkinsfile` will automatically download the latest copy of ConfigMyApp from GitHub.  

Besides running the Jenkins job from your pipeline, various teams can also manage AppDynamics configurations from Jenkins UI (Using the Build with Parameters options) once deployed - as shown below: 

<img width="1047" alt="Jenkins UI" src="https://user-images.githubusercontent.com/2548160/92592883-22bd3f00-f298-11ea-814a-5f9039d752f6.png">


### Freestyle Job

Click "New Item" to create a new Jenkins job, and pick a "Freestyle" project from the list, and pick an appropriate name and add a description:

![Jenkins_new_item](https://user-images.githubusercontent.com/23483887/87525582-9ae4fb00-c681-11ea-96e8-946032c70141.png)

In job configuration, check the "This project is parameterized" checkbox in the "General" section to add environment variables as String variables:

<img width="928" alt="jenkins_parameters" src="https://user-images.githubusercontent.com/23483887/87810713-501bdc80-c855-11ea-98f3-cde9406f44f9.png">

Under "Source Code Management" tab specify the GitHub project:

<img width="940" alt="Jenkins_source_repo" src="https://user-images.githubusercontent.com/23483887/87811459-a3425f00-c856-11ea-973c-5376d660f439.png">

In the "Build" tab, as a build step add "Execute shell" and execute the `start.sh` script in a similar fashion as you would from the command line. Bear in mind that we defined environment variables in the previous step and you need to specify only additional runtime parameters that you may require:

<img width="937" alt="Jenkins_build_steps" src="https://user-images.githubusercontent.com/23483887/87811561-c40ab480-c856-11ea-990a-afa36645b15f.png">

## Run Jenkins Job

In order to change any of the configurations, from the left-side menu inside of a project click "Configure". To run a Jenkins job, pick "Build with Parameters". 

<img width="972" alt="Jenkins_build_with_params" src="https://user-images.githubusercontent.com/23483887/87811696-fa483400-c856-11ea-999f-0d79062c2832.png">

You are going to be prompted with environment variables defined that you can update prior to running a job. Click on the "Build", and check the progress in build history and "Console output".

<img width="1071" alt="Jenkins_console_output" src="https://user-images.githubusercontent.com/23483887/87810537-11862200-c855-11ea-9486-1787c903163d.png">

## Job Definitions

An example of a Jenkins job definition can also be found in project source code:

```
integrations/Jenkins/JenkinsJobFile.xml
``` 
