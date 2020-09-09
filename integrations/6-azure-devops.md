---
sort: 6
---

# Azure DevOps   


ConfigMyApp  can also be executed from AzureDevOps. 

We created a sample AzureDevops pipeline yaml that can easily be adapted to suit your existing pipeline.  Refer to the <a href="https://github.com/Appdynamics/ConfigMyApp/blob/master/integrations/azure-devops/azure-pipelines.yml" target="_blank"> azure-pipelines.yml file </a> in the repostory. 

As well as running ConfigMyApp from a your pipeline's repository, you can also configure AzureDevops UI to manaully trigger ConfigMyApp. This can be done be creating environment variables in AzureDevops: 

![AzureDevops UI](https://user-images.githubusercontent.com/2548160/92592207-21d7dd80-f297-11ea-8a96-793e2126ad37.png)

Once deployed, the expected outpu in AzureDevops console should be similar the screenshot shown below: 

![AzureDevOps console](https://raw.githubusercontent.com/Appdynamics/ConfigMyApp/master/integrations/azure-devops/azure-devops.png)
