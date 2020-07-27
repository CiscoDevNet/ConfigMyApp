---
sort: 11
toc: true
{:toc}
---

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

```bash
./start.sh --application-name <app-name>  --no-overwrite-health-rules
```

> Business transactions

```bash
./start.sh --application-name <app-name>  --configure-bt
```

```bash
./start.sh --application-name <app-name>  ---bt-only
```

> Full configuration parameters

```yaml
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

```json
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
```

and this Java servlet example below shows an example of using REGEX matching condition:

```json
    "java_servlet_rules": [
      {
       "rule_name": "LogonServlet_test",
       "matching_condition":"MATCHES_REGEX",
       "matching_strings": "^user.*(\/login)$",
       "priority":"7"
      }
    ]   
```
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

```json
    "branding": [
    {
      "enabled": true,
      "logo_file_name": "logo.png",
      "background_file_name": "background.jpg"
    }
    ]
```

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
