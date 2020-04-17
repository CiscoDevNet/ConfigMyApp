# ConfigMyApp

ConfigMyApp is a Self-Service AppDynamics configuration tool, this tool is a your AppDynamamics config-as-code enabler - and it can be embedded into your deployment pipelines,  such as Jenkins and Harness. 
 
ConfigMyApp automatically configures an AppDynamics application by applying the following configurations: 
 - Health rule creation for Server Visibility to monitor CPU and memory
 - Health rule creation for the application business transactions, tiers
   and nodes health  
 - Automated creation of Dashboards  Automated creation of transaction
   detection rules

 **Prerequisites**
 
 `jq` is required. Download and install `jq` from https://stedolan.github.io/jq/download/ 

 **Set Up**
 1. Add a logo image and a backaground image to the branding folder. 
 2. Using your favourite text editor, open config.json and fill in the configuration properties:

  | **Config Property Name** | **Description** |
  | --- | --- |
  | overwrite_health_rules  | Set to true to have health rules in the posted data overwrite existing health rules with the same name. The default is true. |
  | url  | The full URL of your AppDynamics controller |
  | username  | The service account username |
  | password  | The service account password  |
  | server_viz_app_id  | Login to the controller, click the Servers tab and copy the value of the application ID from the URL |
  | proxy_url  | Define HTTP proxy host if in use, otherwise leave it blank.  |
  | proxy_port | Define proxy port if `proxy_url` is not blank |

You may run this script in a silent mode, or in an interactive mode: 

**Running in Silent Mode** 

     ./configMyApp.sh <application_name> <database_name> <environment> <configbt>

The position of the argument matters!

 - application_name : This represents the business application name in
   the AppDynamics controller.
 - database_name : Get the name of the database collector for this
   application from the Databases menu in the controller. If this
   application is not associated with any database, enter no, or none.
   If the database collect has spaces in it, put the name within single
   quotes.
example, .

       /configMyApp.sh inflation-prod 'CORP – SQL Server' prod

 - environment: Enter one of prod, uat, test, dev, etc. This represents
   the environment of your application and will determine the Controller
   (dev or prod) to use. If this argument isn’t one of prod, PROD,
   production, PRODUCTION, it defaults to the non-production controller.

 - Configbt – This flag is used to automate business transaction
   configuration. It’s an optional flag. If set to one of yes, bt or
   configbt, it checks the parent folder to see if a file match
   <application_name>.xml, then uploads the pre-configured business
   transaction to AppDynamics. To have this script automatically
   configure business transactions, make a copy of the
   BTConfigTemplate.xml file, then find and replace the following text
   with your POCO or POJO details.

 *- TemplateRuleName*
 
 *- TemplateClassName and*
 
 *- TemplateMethodName*

 - The <rule> section for each business transaction detection rule. The
   template provides an example for .Net and Java respectively.

**Running in Interactive Mode**
Simply execute configMyApp.sh and follow the onscreen instructions. 

**Business Transaction Mode**

To create only business transaction detection rules without Health rules and dashboards, run the configBT.sh script as shown below. 

    ./configBT.sh <application-name>

This requires the template rule name to be an exact match of application-name. For example, inflation-qa.xml, where inflation-qa is the application name in the AppDynamics controller. 

Note: After deploying this script, you’re expected to modify the subgroup of the server visibility health rules.  Navigate to Servers – Health Rules, type the application name in the search box, you should now see two health rules – for CPU and Memory. Modify the affected entities for each health rule by changing the subgroups from root to the appropriate subgroup of servers for the application. Type the application name in the search to find the appropriate subgroups. 

**RBAC**

TODO - ConfigMyApp service account roles. 
