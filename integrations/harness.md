---
sort: 21
---
<p><img align="right" width="200" height="60" src="https://user-images.githubusercontent.com/23483887/87051577-a9ea2a00-c1f7-11ea-9ab8-4781d043e9bc.png"></p>

# Harness.io

Harness.io is a Continuous Delivery as a Service enterprise platform for automation of application and micro-service deployments.

## Running for the first time - setup

In case that on your account you already have an application and workflow with steps set, proceed to the next chapter to <a href="https://appdynamics.github.io/ConfigMyApp/#run-harnessio-script">run the Harness.io deployment</a>, otherwise proceed to the next section.

## Create an application and a workflow

To create an application, if it does not exist, go to Configure and add an application:

![Harness_new_app](https://user-images.githubusercontent.com/23483887/87537282-48f8a100-c692-11ea-8638-79098fb97fd6.png)

Create a new Workflow of a type "Build Workflow":

![Harness_workflow](https://user-images.githubusercontent.com/23483887/87538269-db4d7480-c693-11ea-98e4-40cb08adbc14.png)

### Add workflow variables and steps

Add workflow variables, at the minimum GITHUB_USER, GITHUB_PASSWORD, and GITHUB_BRANCH:

![Harness_env_vars](https://user-images.githubusercontent.com/23483887/87538628-6af32300-c694-11ea-8695-c85f9e142b88.png)

Add workflow steps for pulling the data from GitHub and executing the `start.sh` script, for example:

![Harness_workflow_steps](https://user-images.githubusercontent.com/23483887/87538756-b0175500-c694-11ea-9753-de250e3fc3a6.png)

Workflow step type should be Shell Script, and to pull data from a GitHub repo install the necessary packages and use already defined workflow variables:

![Harness_step_1_github](https://user-images.githubusercontent.com/23483887/87539172-58c5b480-c695-11ea-9099-8cb5318b5262.png)

In next step, we are using the downloaded source code to run the `start.sh` script. Note that we are can set environment variables as workflow variables and in start script only overrides runtime parameter default values and/or environment variable values if necessary:

![Harness_step_2_start](https://user-images.githubusercontent.com/23483887/87539231-6f6c0b80-c695-11ea-851e-a87cbeeea1f2.png)

Note: In project source code you can find an example of a workflow, under the `integrations/Harnessio` directory:

```
integrations/Harnessio/Workflow.yml
```

### Run Harness.io deployment

Navigate to Setup, choose your Application from a list, and pick a Workflow that you wish to use. Click Deploy and update environment variables if necessary when prompted, similar to the screenshot below:

![Harness_io_deploy](https://user-images.githubusercontent.com/23483887/87539640-29fc0e00-c696-11ea-9cfd-ce36ac7a9eb9.png)

This will trigger your deployment and you can track progress in console output on the right side of the Harness.io UI.
