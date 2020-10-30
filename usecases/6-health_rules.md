---
sort: 6

---

# Health Rules

We have used our experience from working with diverse customers to collate a pre-canned set of best-practice 'application' and 'server visibility' health rules in ConfigMyApp. These health rules are located in the `healthrules` folder.  You may adjust the thresholds of the health rules to match your specific needs. 

Furthermore, you can add more health rules should you wish to do so; ConfigMyApp will automatically process all the `JSON` files that are in the `health_rules\Application` folder and `health_rules\ServerVisibility` folder respectively. To minimize the chances of an error, we recommend that you create the new health rule in the controller first, then export into a JSON file. Once that is done, place the new JSON file into either the Application or Server Visibility folder.

Please refer to the <a href="https://docs.appdynamics.com/display/PRO45/Health+Rule+API"> Health Rule API</a> documentation for further details. 

ConfigMyApp will skip a health rule if it exists in the controller. You would need to explicitly set the overwrite flag to true if you wish to overwrite existing health rules.

## 1. Configure Health Rules Only

<b> Runtime parameters</b>

`./start.sh -c http://appd.saas.com -a MyApp --username=appd --password=appd --health-rules-only`

<b>Environment variables</b>

`CMA_HEALTH_RULES_ONLY=true`

<b>Configuration file (`config.json`)</b>

` "health_rules_only": true`

## 2. Overwrite Existing Health Rules or Not

<b> Runtime parameters</b>

`./start.sh -c http://appd.saas.com -a MyApp --username=appd --password=appd --health-rules-overwrite`

or 

`./start.sh -c http://appd.saas.com -a MyApp --username=appd --password=appd --no-health-rules-overwrite`

<b>Environment variables</b>

`CMA_HEALTH_RULES_OVERWRITE=true`

<b>Configuration file (`config.json`)</b>

` "health_rules_overwrite": true`

## 3. Delete Health Rules

<b> Runtime parameters</b>

`./start.sh -c http://appd.saas.com -a MyApp --username=appd --password=appd --health-rules-delete "<health_rule_name>, <another_health_rule_name>"`

<b>Environment variables</b>

`CMA_HEALTH_RULES_DELETE="health_rule_name, another_health_rule_name"`

<b>Configuration file (`config.json`)</b>

` "health_rules_delete": "health_rule_name, another_health_rule_name"`
