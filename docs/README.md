<center>. . .</center>

# Introduction

ConfigMyApp is a <b>monitoring-as-a-service</b> solution that automates the configuration of AppDynamics business applications, Server Viz, dashboarding, etc without the need to manually login to the controller. 

ConfigMyApp enhances rapid rollout of AppDynamics.  We built it based on the DevOps configuration-as-code paradigm with a simple objective - the ability to configure AppDynamics from your existing Continuous Integration and Deployment (CI/CD) platform - such as Jenkins, Harness, TeamCity, GitLab, Bamboo. In addition, ConfigMyApp can be executed from the official Docker image and Kubernetes. 

Configuration as code allows the entire configurations to be stored as source code.  It moves the managing of certain configurations from the UI to the developer's integrated development environment. This approach brings a lot of benefits, i.e. versioning of changes, traceability of changes, smooth promotion of config changes from test to production controller, etc. 

ConfigMyApp saves time, hassle and cost, as it reduces human error and time-to-value while it maintains consistency of thresholds and naming conventions across your estate.  

# Supported Components 

ConfigMyApp supports the configuration of the following AppDynamics components: 

 - Business transactions detection rules <br> 
   Support for INCLUDE and EXCLUDE rules for the following types of transactions: 
    - .NET classes and methods (POCOs) 
    - Java classes and methods (POJOs)
    - Servlets 
    - ASPs
 - Server Visibility 
 - Business Application 
 - DB Monitoring
 - Custom dashboard with support for custom logo and background images.
 
# Prerequisites
 The following requirements must be met to run ConfigMyApp: 

 1. It's only supported on Linux/Unix and macOS. Tested on Ubuntu, CentOS and MacOS
 2. `jq` must be installed on your machine 
 3. `awk` must be installed on the machine 
 4. `sed` must be installed on the machine 
 
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

# How it works 
 
The diagram below depicts a high-level flow on how ConfigMyApp works. 

![How it works](https://user-images.githubusercontent.com/2548160/87234693-719b4500-c3cb-11ea-9fab-fa82d3e30f21.png)


## Sample Output 

Besides the automated business transaction and health rule configuration features, ConfigMyApp can provide the ability to create a dynamic dashboard as shown below. The server visibility and database monitoring health rule configurations are optional items. Refer to the <a href="https://appdynamics.github.io/ConfigMyApp/#configuring-input-parameters"> configuring input parameters</a> for more details.

![dashboard](https://user-images.githubusercontent.com/2548160/87234207-bec8e800-c3c6-11ea-9858-c857fb0b7470.png)

Note that the branding; which consists of the logo and the background image, can be easily changed by copying your own chosen custom images into the `branding` folder in the root directory. Refer to the <a href="https://appdynamics.github.io/ConfigMyApp/#branding"> branding section</a> for further details.
 
## Configuring input parameters

ConfigMyApp accepts arguments from the following 3 (combined) sources:- runtime, environment variables and `config.json` file

The order of parameter precedence is as follows:-

 1. Runtime parameters 
 2. Environment variables 
 3. Configuration file `config.json` 

So in summary, runtime parameters have precedence over environment variables, and environment variables have precedence over configuration `JSON` file. 

Note that mandatory parameters need to be provided in any (and not all) of the three configuration methods listed above for ConfigMyApp to be able to start.

## Runtime parameters  

Use the `--help` command to get a list of the available runtime parameters as shown below: 

```
./start.sh --help
```

The table below describes the supported runtime arguments: 

| Section       | Parameter<img>  | Description  | Mandatory  |
| ------ |:------- | :--------- |  :----: |
| Connection | `-c, --controller-host` | controller host (no default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"> |
| Connection | `-P, --controller-port` | controller port (8090 by default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Connection | `--use-https, --no-use-https` | if true, specifies that the agent should use SSL (false by default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Account | `--account` | account name (customer1 by default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"> |
| Account | `-u, --username` | appd user username (no default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"> |
| Account | `-p, --password` | appd user password (no default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"> |
| Account | `--use-encoded-credentials, --no-use-encoded-credentials` | use base64 encoded credentials (false by default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Proxy | `--use-proxy, --no-use-proxy` | use proxy optional argument (false by default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Proxy | `--proxy-url` | proxy url (no default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Proxy | `--proxy-port` | proxy port (no default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Branding | `--use-branding, --no-use-branding` | enable branding (true by default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Branding | `--logo-name` | logo image file name (no default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Branding | `--background-name` | background image file name (no default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `-a, --application-name` | application name (no default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"> |
| Application | `--include-database, --no-include-database` | include database (false by default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `-d, --database-name` | database name, mandatory if include-database set to true (no default) |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `-s, --include-sim` | include server visibility (false by default) |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `-b, --configure-bt` | configure busness transactions (false by default) |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `--overwrite-health-rules` | overwrite health rules (true by default) |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `--bt-only, --no-bt-only` | configure business transactions only  |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |

You can run the script in debug mode by using `--debug` flag, in which case the connection and other parameters used will be printed out in the console. We do not recommend using this flag in production, and it is set to `false` by default.

## Environment variables

Environment variables used by ConfigMyApp start with `CMA_` and if not empty, will be used to fill-in parameters values not explicitly set at runtime. <br>

The table below describes the supported environment variables: 

<table id="envTable" class="display">
  <thead>
    <tr>
      <th>Section</th>
      <th style="text-align: left">Environment Variable</th>
      <th style="text-align: left">Description</th>
      <th style="text-align: center">Mandatory</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Connection</td>
      <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_CONTROLLER_HOST</code></td>
      <td style="text-align: left">controller host</td>
      <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"></td>
    </tr>
    <tr>
      <td>Connection</td>
      <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_CONTROLLER_PORT</code></td>
      <td style="text-align: left">controller port</td>
      <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
    </tr>
    <tr>
      <td>Connection</td>
      <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_USE_HTTPS</code></td>
      <td style="text-align: left">if true, specifies that the agent should use SSL</td>
      <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
    </tr>
    <tr>
      <td>Account</td>
      <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_ACCOUNT</code></td>
      <td style="text-align: left">account name</td>
      <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"></td>
    </tr>
    <tr>
      <td>Account</td>
      <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_USERNAME</code></td>
      <td style="text-align: left">appd user username</td>
      <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"></td>
    </tr>
    <tr>
      <td>Account</td>
      <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_PASSWORD</code></td>
      <td style="text-align: left">appd user password (no default)</td>
      <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"></td>
    </tr>
    <tr>
      <td>Account</td>
      <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_USE_ENCODED_CREDENTIALS</code></td>
      <td style="text-align: left">use base64 encoded credentials</td>
      <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
    </tr>
    <tr>
      <td>Proxy</td>
      <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_USE_PROXY</code></td>
      <td style="text-align: left">use proxy</td>
      <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
    </tr>
    <tr>
      <td>Proxy</td>
      <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_PROXY_URL</code></td>
      <td style="text-align: left">proxy url</td>
      <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
    </tr>
    <tr>
      <td>Proxy</td>
      <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_PROXY_PORT</code></td>
      <td style="text-align: left">proxy port</td>
      <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
    </tr>
    <tr>
      <td>Branding</td>
      <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_USE_BRANDING</code></td>
      <td style="text-align: left">enable branding</td>
      <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
    </tr>
    <tr>
      <td>Branding</td>
      <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_LOGO_NAME</code></td>
      <td style="text-align: left">logo image file name</td>
      <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
    </tr>
    <tr>
      <td>Branding</td>
      <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_BACKGROUND_NAME</code></td>
      <td style="text-align: left">background image file name</td>
      <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
    </tr>
    <tr>
      <td>Application</td>
      <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_APPLICATION_NAME</code></td>
      <td style="text-align: left">application name</td>
      <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"></td>
    </tr>
    <tr>
      <td>Application</td>
      <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_INCLUDE_DATABASE</code></td>
      <td style="text-align: left">include database</td>
      <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
    </tr>
    <tr>
      <td>Application</td>
      <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_DATABASE_NAME</code></td>
      <td style="text-align: left">database name, mandatory if include-database set to true</td>
      <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
    </tr>
    <tr>
      <td>Application</td>
      <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_INCLUDE_SIM</code></td>
      <td style="text-align: left">include server visibility</td>
      <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
    </tr>
    <tr>
      <td>Application</td>
      <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_CONFIGURE_BT</code></td>
      <td style="text-align: left">configure busness transactions</td>
      <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
    </tr>
    <tr>
      <td>Application</td>
      <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_OVERWRITE_HEALTH_RULES</code></td>
      <td style="text-align: left">overwrite health rules</td>
      <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
    </tr>
    <tr>
      <td>Application</td>
      <td style="text-align: left"><code class="language-plaintext highlighter-rouge">CMA_BT_ONLY</code></td>
      <td style="text-align: left">configure business transactions only</td>
      <td style="text-align: center"><img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"></td>
    </tr>
  </tbody>
</table>


## Configuration file

ConfigMyApp uses a `config.json` configuration file which can be found in the root of the project. The values in the configuration file are only used when the runtime parameter is not defined and the environment for the same parameter does not exist. <br>

The table below describe the JSON configuration:

| Section       | JSON path  | Description  | Mandatory |
| ------ |:------- | :--------- |  :----: |
| Connection | `.controller_details[].host` | controller host | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"> |
| Connection | `.controller_details[].port` | controller port | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Connection | `.controller_details[].use_https` | if true, specifies that the agent should use SSL | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Account | `.controller_details[].account` | account name | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"> |
| Account | `.controller_details[].username` | appd user username | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"> |
| Account | `.controller_details[].password` | appd user password (no default) | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"> |
| Account | `.are_passwords_encoded` | use base64 encoded credentials  | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Proxy | `.controller_details[].use_proxy` | use proxy | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Proxy | `.controller_details[].proxy_url` | proxy url | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Proxy | `.controller_details[].proxy_port` | proxy port | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Branding | `.branding[].enabled` | enable branding | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Branding | `.branding[].logo_file_name` | logo image file name | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Branding | `.branding[].background_file_name` | background image file name | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `.configuration[].application_name` | application name | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2714.png" width="20" height="20"> |
| Application | `.configuration[].include_database` | include database | <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `.configuration[].database_name` | database name, mandatory if include-database set to true |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `.configuration[].include_sim` | include server visibility |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `.configuration[].configure_bt` | configure busness transactions |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |
| Application | `.overwrite_health_rules` | overwrite health rules |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20">|
| Application | `.configuration[].bt_only` | configure business transactions only  |  <img src="https://github.githubassets.com/images/icons/emoji/unicode/2716.png" width="20" height="20"> |


# Running ConfigMyApp

This section contains examples of running an instance of ConfigMyApp, it should be adjusted to fit your use-case and here are some of the common ones

## Common scenarios  

> Server visibility

```
./start.sh --application-name <app-name> --include-sim
```

> Database visibility

```
./start.sh --application-name <app-name> --include-database  ---database=’DB collector name’
```

> Health rules

```
./start.sh --application-name <app-name>  --no-overwrite-health-rules
```

> Business transactions

```
./start.sh --application-name <app-name>  --configure-bt
```
```
./start.sh --application-name <app-name>  ---bt-only
```

> Full configuration parameters

```
./start.sh --application-name <app-name>  \ 
           -c "http://customer1.saas.appdynamics.com" \ 
           -P “8090” \ 
           --account customer1 \
           -p "<password>" \ 
           --use-encoded-credentials \
           -u "username" \ 
           --configure-bt \
           --include-database \
           --database-name 'DB Collector Name' \
           --include-sim  \ 
           --use-https false  \ 
           --proxy-url localhost  \
           --proxy-port 3303  \ 
           --overwrite-health-rules 
                  
```

## Business Transaction Configuration 

Business transaction detection rules can be configured by using the template file in <a href="https://github.com/Appdynamics/ConfigMyApp/tree/master/bt_config"> `bt_config/configBT.json` </a>. The `JSON` file contains four arrays which represent the four types of business transaction rules, which are currently supported by ConfigMyApp. For example, the Java POJO section looks like: 

    "java_pojo_rules": [
       {
        "include_or_exclude_rule": "exclude",
        "rule_name": "getStatus_test",
        "class_name": "com.appdynamics.health.Class",
        "class_matching_condition":"STARTS_WITH",
        "method_name": "getStatus",
        "method_matching_condition":"EQUALS",
        "priority":"10"
       }
     ]
     
and this Java servlet example below shows an example of using REGEX matching condition: 

    "java_servlet_rules": [
      {
       "rule_name": "LogonServlet_test",
       "matching_condition":"MATCHES_REGEX",
       "matching_strings": "^user.*(\/login)$",
       "priority":"7"
      }
    ]   
  
The supported transaction types are: 

`java_pojo_rules`, `dotnet_poco_rules`, `dotnet_asp_rules` and `java_servlet_rules`

The supported match-type ENUMS are: 

`MATCHES_REGEX`, `CONTAINS`, `EQUALS`, `STARTS_WITH`, `ENDS_WITH`, `IS_IN_LIST` and `IS_NOT_EMPTY`
     
The format of the `JSON` must be maintained at all times, all four sections must be available even if you're not using them, leave it blank if you're not using it. 

## Branding 

ConfigMyApp uses the `logo.png` and the `background.jpg` file in the `branding` folder by default. We recommend that you replace both files with your company's images. Alternatively, you may add more images into the `branding` folder and specify the image names as extra parameters. See examples below: 

<b> Run time Paramaters</b>

`./start.sh -c http://appd-cx.com -a API_Gateway -u appd -p appd --use-branding --logo-name="logo-white.png" --background-name="appd-bg.jpg"`

<b>Environment Varaibles</b>
```
CMA_USE_BRANDING=true
CMA_BACKGROUND_NAME=<bg_image_name>.<file-extension>
CMA_LOGO_NAME=<logo_image_name>.<file-extension>

```
<b>Configuration file (`config.json`)</b>

    "branding": [
    {
      "enabled": true,
      "logo_file_name": "logo.png",
      "background_file_name": "background.jpg"
    }
    ]

## Proxy Settings 

If your AppDynamics controller is behind a proxy, ConfigMyApp lets you specify the Proxy Host and Port. Proxy authentication is not supported. 

<b> Run time Paramaters</b>
`./start.sh -c http://appd-cx.com -a API_Gateway -u appd -p appd --use-proxy 	--proxy-url="10.3.5.9" --proxy-port 8080`

<b>Environment Varaibles</b>

```
CMA_USE_PROXY=true
CMA_PROXY_URL=10.5.9.1
CMA_PROXY_PORT=4993
```
<b>Configuration file (`config.json`)</b>

    "controller_details": [
    {
      [truncated]
      "use_proxy": true,
      "proxy_url": "127.0.0.1",
      "proxy_port": "8030" 
    }
    ]
    
## Encoded Password  

For added security, ConfigMyApp supports base64 password encoding. For example 

`echo "password" | base64` outputs  `YXBwZAo=` 

which can be used in ConfigMyApp instead of the plain text `password`

<b> Run time Paramaters</b>

`./start.sh -c http://appd.saas.com -a MyApp -u appd -p YXBwZAo=  --use-encoded-credentials`

<b>Environment Varaibles</b>

```
CMA_PASSWORD=YXBwZAo=
CMA_USE_ENCODED_CREDENTIALS=true
```
<b>Configuration file (`config.json`)</b>

` "are_passwords_encoded": true`

## Health Rules 

We have used our experience from working with diverse customers to collate a pre-canned set of best-practice 'application' and 'server visibility' health rules in ConfigMyApp. These health rules are located in the `healthrules` folder.  You may adjust the thresholds of the health rules to match your specific needs. 

Furthermore, you can add more health rules should you wish to do so; ConfigMyApp will automatically process all the `JSON` files that are in the `healthrules\Application` folder and `healthrules\ServerVisibility` folder respectively. To minimize the chances of an error, we recommend that you create the new health rule in the controller first, then export into a JSON file. Once that is done, place the new JSON file into either the Application or ServerVisbility folder. 

Please refer to the <a href="https://docs.appdynamics.com/display/PRO45/Health+Rule+API"> Health Rule API</a> documentation for further details. 

ConfigMyApp will skip a health rule if it exists in the controller. You would need to explicitly set the overwrite flag to true if you wish to overwrite existing health rules. 

<b> Run time Paramaters</b>

`./start.sh -c http://appd.saas.com -a MyApp --username=appd --password=appd --overwrite-health-rules`

<b>Environment Varaibles</b>

`CMA_OVERWRITE_HEALTH_RULES=true`

<b>Configuration file (`config.json`)</b>

` "overwrite_health_rules": true`

# Integrations 

This section describes practical examples on how to run ConfigMyApp from  Docker, Kubernetes, Harness and Jenkins. 

<p><img align="right" width="200" height="75" src="https://user-images.githubusercontent.com/2548160/87821525-e3f6a400-c867-11ea-8f27-edcfe83a6108.png"></p>


## Docker 

You can run ConfigMyApp by using either the official docker image or you can build a custom docker image from the source code. 

### ConfigMyApp docker image 

ConfigMyApp images are available from Docker hub and can be downloaded using `docker pull`. For example: 

`docker pull appdynamicscx/configmyapp:latest`

### Build a custom docker image

Alternatively, you may build your own ConfigMyApp image using the following steps: 

1. Clone the <a href="https://github.com/Appdynamics/ConfigMyApp" target="_blank">repository</a>
2. change directory the docker folder
3. Run  `./build.sh <tag_name> <image_name>`  

### Docker run

The `run.sh` script in the docker folder contains 3 examples (standard, BT, and branding) on how to run the configMyApp docker image. 

First, you would need to define your environment variables using the `env.list` file in the docker folder as an example. 

Standard run: 

`docker run --name ConfigMyApp --env-file env.list appdynamicscx/configmyapp:latest` 

#### Mount branding volume

To use your company's logo and background images, use the following steps: 

1. Create a folder called `branding`, add both images into the folder.
2. In the `env.list` file, add the following BRANDING environment variables:

```
CMA_USE_BRANDING=true
CMA_BACKGROUND_NAME=<bg_image_name>.<file-extension>
CMA_LOGO_NAME=<logo_image_name>.<file-extension>

```
 3.Mount the `branding` volume in docker run. The docker run command should be executed from the `branding` folder on your host. 

 ``` 
 docker run -d \
      --name ConfigMyApp
      --mount type=bind,source=$(pwd)/branding,destination=/opt/configmyapp/branding \
      --env-file docker/env.list  appdynamicscx/configmyapp:latest
 ```
Note: Do not use qoutes in the environment variable values, and it's *NOT* best practice to use spaces in the file name. 

#### Mount business transaction volume 

Use the following steps to automate business transaction configuration using the docker image:

1. Create a folder called `bt_config` 
2. Copy the `configBT.json` file from the project into the `bt_config` folder on your docker host 
3. Make necessary adjustments to the folder depending on your need. Please refer to the <a href="https://appdynamics.github.io/ConfigMyApp/#business-transaction-configuration"> business transaction configuration</a> section for details
4. Mount the `bt_config` volume in docker run. The docker run command should be executed from the `bt_config` folder on your host. 

```
docker run -d \
  --name ConfigMyApp
  --mount type=bind,source=$(pwd)/bt_config,destination=/opt/configmyapp/bt_config \
  appdynamicscx/configmyapp:latest
```

Once your contaienr is up and running, execute `docker ps` to check the container status, then tail the logs: 

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

<p><img align="right" width="200" height="57" src="https://user-images.githubusercontent.com/23483887/87779752-39f62800-c825-11ea-9c8c-66be52d131c8.png"></p>

## Kubernetes  

All files relevant for Kubernetes deployment can be found in `/kubernetes` directory of a project.

## Updating secrets and environment variables

1. Update the password in the `cma-pass-secret.yml` with your controller's user password base64 encoded.

2. Update environment variables defined in a file `cma-configmap.yaml`.

3. In a pod definition that you pick, for example, `cma-pod-standard.yml`, set the `env:` section to reflect your application and/or controller settings. 

## Create a Pod

Example command of how to create the Pod:
```
kubectl apply -f <pod-manifest.yaml>
```

You can use some of the available Pod specifications, currently available are:
- `cma-pod-standard.yml` - standard deployment, without Business Transactions and Branding,
- `cma-pod-bt-volume.yml` - includes Business Transactions from `bt-config.yml` file,
- `cma-pod-branding-volume.yml` - mounts a volume for Branding feature.

Verify that the ConfigMyApp container is running:
```
kubectl get pod <pod-name>
```


<p><img align="right" width="200" height="60" src="https://user-images.githubusercontent.com/23483887/87051577-a9ea2a00-c1f7-11ea-9ab8-4781d043e9bc.png"></p>

## Harness.io

Harness.io is a Continuous Delivery as a Service enterprise platform for automation of application and micro-service deployments.


### Running for the first time - setup

In case that on your account you already have an application and workflow with steps set, proceed to the next chapter to <a href="https://appdynamics.github.io/ConfigMyApp/#run-harnessio-script">run the Harness.io deployment</a>, otherwise proceed to the next section.

#### Create an application and workflow

To create an application, if it does not exist, go to Configure and add an application:

![Harness_new_app](https://user-images.githubusercontent.com/23483887/87537282-48f8a100-c692-11ea-8638-79098fb97fd6.png)

Create a new Workflow of a type "Build Workflow":

![Harness_workflow](https://user-images.githubusercontent.com/23483887/87538269-db4d7480-c693-11ea-98e4-40cb08adbc14.png)

#### Add workflow variables and steps

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


<p><img align="right" width="200" height="60" src="https://user-images.githubusercontent.com/23483887/87051994-33016100-c1f8-11ea-847f-38da20685581.png"></p>

## Jenkins

Jenkins is a free and open-source automation server. It helps automate the parts of software development related to building, testing, and deploying, facilitating continuous integration and continuous delivery.


### Running for the first time - setup

If you are running Jenkins for the first time, you need to set up a job with the steps below. If you already specified the job, jump to the next chapter to <a href="https://appdynamics.github.io/ConfigMyApp/#run-jenkins-job">run the Jenkins job</a>, otherwise proceed to the next section.

#### Plugins

If you installed recommended packages you may already have GitHub plugin, if you do not then navigate to "Manage Jenkins" and choose "Manage Plugins", search for "git plugin", and click on "Install without restart". You should be seeing GitHub plugin installed:

<img width="1406" alt="Jenkins_plugin" src="https://user-images.githubusercontent.com/23483887/87814360-7fcde300-c85b-11ea-8875-c38ae77d2b70.png">

#### Create Jenkins Job

Click "New Item" to create a new Jenkins job, and pick a "Freestyle" project from the list, and pick an appropriate name and add a description:

![Jenkins_new_item](https://user-images.githubusercontent.com/23483887/87525582-9ae4fb00-c681-11ea-96e8-946032c70141.png)

In job configuration, check the "This project is parameterized" checkbox in the "General" section to add environment variables as String variables:

<img width="928" alt="jenkins_parameters" src="https://user-images.githubusercontent.com/23483887/87810713-501bdc80-c855-11ea-98f3-cde9406f44f9.png">

Under "Source Code Management" tab specify the GitHub project:

<img width="940" alt="Jenkins_source_repo" src="https://user-images.githubusercontent.com/23483887/87811459-a3425f00-c856-11ea-973c-5376d660f439.png">

In the "Build" tab, as a build step add "Execute shell" and execute the `start.sh` script in a similar fashion as you would from the command line. Bear in mind that we defined environment variables in the previous step and you need to specify only additional runtime parameters that you may require:

<img width="937" alt="Jenkins_build_steps" src="https://user-images.githubusercontent.com/23483887/87811561-c40ab480-c856-11ea-990a-afa36645b15f.png">

### Run Jenkins Job

In order to change any of the configurations, from the left-side menu inside of a project click "Configure". To run a Jenkins job, pick "Build with Parameters". 

<img width="972" alt="Jenkins_build_with_params" src="https://user-images.githubusercontent.com/23483887/87811696-fa483400-c856-11ea-999f-0d79062c2832.png">

You are going to be prompted with environment variables defined that you can update prior to running a job. Click on the "Build", and check the progress in build history and "Console output".

<img width="1071" alt="Jenkins_console_output" src="https://user-images.githubusercontent.com/23483887/87810537-11862200-c855-11ea-9486-1787c903163d.png">

### Job Definitions

An example of a Jenkins job definition can also be found in project source code: 
```
integrations/Jenkins/JenkinsJobFile.xml
``` 




