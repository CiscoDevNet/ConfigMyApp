---
sort: 2

---

# Business Transaction Configuration

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
