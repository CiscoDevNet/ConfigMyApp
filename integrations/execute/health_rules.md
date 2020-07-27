---
sort: 16

---

# Health Rules

We have used our experience from working with diverse customers to collate a pre-canned set of best-practice 'application' and 'server visibility' health rules in ConfigMyApp. These health rules are located in the `healthrules` folder.  You may adjust the thresholds of the health rules to match your specific needs. 

Furthermore, you can add more health rules should you wish to do so; ConfigMyApp will automatically process all the `JSON` files that are in the `healthrules\Application` folder and `healthrules\ServerVisibility` folder respectively. To minimize the chances of an error, we recommend that you create the new health rule in the controller first, then export into a JSON file. Once that is done, place the new JSON file into either the Application or Server Visibility folder.

Please refer to the <a href="https://docs.appdynamics.com/display/PRO45/Health+Rule+API"> Health Rule API</a> documentation for further details. 

ConfigMyApp will skip a health rule if it exists in the controller. You would need to explicitly set the overwrite flag to true if you wish to overwrite existing health rules.

<b> Runtime parameters</b>

`./start.sh -c http://appd.saas.com -a MyApp --username=appd --password=appd --overwrite-health-rules`

<b>Environment variables</b>

`CMA_OVERWRITE_HEALTH_RULES=true`

<b>Configuration file (`config.json`)</b>

` "overwrite_health_rules": true`
