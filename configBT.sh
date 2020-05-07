#!/bin/bash
bt_folder="./business_transactions"
bt_conf="configBT.json"
bt_config_template="bt_config_template.xml"
app_name="$1"

poco_temp_file="poco_temp_file.xml"
pojo_temp_file="pojo_temp_file.xml"

poco_scope_temp_file="poco_scope_temp_file.xml"
pojo_scope_temp_file="pojo_scope_temp_file.xml"

#SED variables
template_rule_name="template_bt_rule_name"
template_class_name="template_bt_class_name"
template_method_name="template_bt_method_name"
template_priority="template_bt_priority"
template_desc="template_bt_description"
template_class_match_condition="template_class_match_condition"
template_method_match_condition="template_method_match_condition"

scopes='<rule rule-description="template_bt_description" rule-name="template_bt_rule_name"/>'

java_pojo_tx_rule='<rule agent-type="APPLICATION_SERVER" enabled="true"
            priority="template_bt_priority" rule-description="template_bt_description" rule-name="template_bt_rule_name"
            rule-type="TX_MATCH_RULE" version="1">
            <tx-match-rule>{"type":"CUSTOM","txcustomrule":{"type":"INCLUDE","txentrypointtype":"POJO","matchconditions":
                [{"type":"INSTRUMENTATION_PROBE","instrumentionprobe":{"javadefinition":{"classmatch":{"type":"MATCHES_CLASS",
                "classnamecondition":{"type":"template_class_match_condition","matchstrings":["template_bt_class_name"]}},
                "methodmatch":{"methodnamecondition":{"type":"template_method_match_condition","matchstrings":["template_bt_method_name"]}},
                "methodparamtypes":[]}}}],"actions":[],"properties":[{"type":"BOOLEAN","name":"POJO_BACKUP","booleanvalue":false,
                "ranges":[]}]},"agenttype":"APPLICATION_SERVER"}
            </tx-match-rule>
        </rule>'

dotnet_poco_tx_rule='<rule agent-type="DOT_NET_APPLICATION_SERVER" enabled="true"
            priority="template_bt_priority" rule-description="template_bt_description" rule-name="template_bt_rule_name"
            rule-type="TX_MATCH_RULE" version="1">
            <tx-match-rule>{"type":"CUSTOM","txautodiscoveryrule":{"autodiscoveryconfigs":[]},
                "txcustomrule":{"type":"INCLUDE","txentrypointtype":"POCO","matchconditions":
                [{"type":"INSTRUMENTATION_PROBE","instrumentionprobe":{"javadefinition":
                {"classmatch":{"type":"MATCHES_CLASS","classnamecondition":
                {"type":"template_class_match_condition","matchstrings":["template_bt_class_name"]}},
                "methodmatch":{"methodnamecondition":{"type":"template_method_match_condition","matchstrings":["template_bt_method_name"]}},
                "methodparamtypes":[]}}}],"actions":[],"properties":[{"type":"BOOLEAN","name":"POJO_BACKUP",
                "booleanvalue":false,"ranges":[]}]},"agenttype":"DOT_NET_APPLICATION_SERVER"}
            </tx-match-rule>
        </rule>'

dotnet_poco_func() {
    #these variables need to be global variables as the func is returning multiple values
    dotnet_poco_custom_rules=""
    dotnet_poco_scopes=""
    for row in $(cat "${bt_conf}" | jq -r ' .dotnet_poco_rules[] | @base64'); do
        _ijq() {
            echo ${row} | base64 --decode | jq -r ${1}
        }

        local class_name=$(_ijq '.class_name')
        local method_name=$(_ijq '.method_name')
        local rule_name=$(_ijq '.rule_name')
        local priority=$(_ijq '.priority')
        local class_match_condition=$(_ijq '.class_matching_condition')
        local method_match_condition=$(_ijq '.method_matching_condition')
        local desc="$rule_name :Created on $(date) by ConfigMyApp"

        echo "Processing - ${rule_name} => ${class_name}.${method_name}. With ${class_match_condition} class match condition "
        echo ""

        local rule_handler=$(echo $dotnet_poco_tx_rule | sed "s/${template_rule_name}/${rule_name}/g; s/${template_method_name}/${method_name}/g; s/${template_priority}/${priority}/g; s/${template_class_name}/${class_name}/g; s/${template_desc}/${desc}/g; s/${template_class_match_condition}/${class_match_condition}/g; s/${template_method_match_condition}/${method_match_condition}/g")
        dotnet_poco_custom_rules+="         <!-- $class_name.$rule_name -->"$'\n'"        $rule_handler"$'\n'
        local scope_handler=$(echo $scopes | sed "s/${template_rule_name}/${rule_name}/g; s/${template_desc}/${desc}/g")
        dotnet_poco_scopes+="        $scope_handler"$'\n'
    done #end poco loop
    #echo "$dotnet_poco_custom_rules"
    #echo "$dotnet_poco_scopes"
}

java_pojo_func() {
    java_pojo_custom_rules=""
    java_pojo_scopes=""
    for row in $(cat "${bt_conf}" | jq -r ' .java_pojo_rules[] | @base64'); do

        _ijq() {
            echo ${row} | base64 --decode | jq -r ${1}
        }

        local class_name=$(_ijq '.class_name')
        local method_name=$(_ijq '.method_name')
        local rule_name=$(_ijq '.rule_name')
        local priority=$(_ijq '.priority')
        local class_match_condition=$(_ijq '.class_matching_condition')
        local method_match_condition=$(_ijq '.method_matching_condition')
        local desc="$rule_name :Created on $(date) by ConfigMyApp"

        echo "Processing - ${rule_name} => ${class_name}.${method_name}. With ${class_match_condition} class match condition "
        echo ""

        local rule_handler=$(echo $java_pojo_tx_rule | sed "s/${template_rule_name}/${rule_name}/g; s/${template_method_name}/${method_name}/g; s/${template_priority}/${priority}/g; s/${template_class_name}/${class_name}/g; s/${template_desc}/${desc}/g; s/${template_class_match_condition}/${class_match_condition}/g; s/${template_method_match_condition}/${method_match_condition}/g")
        java_pojo_custom_rules+="        <!-- $class_name.$rule_name -->"$'\n'"        $rule_handler"$'\n'
        local scope_handler=$(echo $scopes | sed "s/${template_rule_name}/${rule_name}/g; s/${template_desc}/${desc}/g")
        java_pojo_scopes+="        $scope_handler"$'\n'
    done #end pjo loop
    #echo "$java_pojo_custom_rules" > jout.xml
    #echo "$java_pojo_scopes" > jscope.out
}

#Call the POCO function
dotnet_poco_func
# echo "$dotnet_poco_custom_rules"
#echo "$dotnet_poco_scopes"

#Call the POJO  function
java_pojo_func
# echo "$java_pojo_custom_rules" > jout.xml
# echo "$java_pojo_scopes" > jscope.xml

#Create .Net POCO temp file

echo "$dotnet_poco_custom_rules" >"$bt_folder/$poco_temp_file"

#Create Java POJO temp file
echo "$java_pojo_custom_rules" >"$bt_folder/$pojo_temp_file"

echo "$dotnet_poco_scopes" >"$bt_folder/$poco_scope_temp_file"

echo "$java_pojo_scopes" >"$bt_folder/$pojo_scope_temp_file"

dt=$(date '+%Y-%m-%d_%H-%M-%S')

bt_file_path="$bt_folder/$app_name-$dt.xml"

cp "$bt_folder/$bt_config_template" "$bt_file_path"

sed -i -e "/<!--POCO-PLACEHOLDER-->/r $bt_folder/$poco_temp_file" -e "//d" "$bt_file_path"

sed -i -e "/<!--POJO-PLACEHOLDER-->/r $bt_folder/$pojo_temp_file" -e "//d" "$bt_file_path"

sed -i -e "/<!--POJO-SCOPE-PLACEHOLDER-->/r $bt_folder/$pojo_scope_temp_file" -e "//d" "$bt_file_path"

sed -i -e "/<!--POOCO-SCOPE-PLACEHOLDER-->/r $bt_folder/$poco_scope_temp_file" -e "//d" "$bt_file_path"

#delete the temp files
sleep 1
rm $bt_folder/*temp_file.xml

if [ -f "$bt_file_path" ]; then
    echo "The business transaction detection rule file has been generated"
    echo ""
    echo "The file path is $bt_file_path"
    sleep 1
    echo ""
    echo "Please wait while we configure BT detection rules in $appName"

    btendpoint="/controller/transactiondetection/${appName}/custom"
    bt_response=$(curl -s -X POST -w "%{http_code}" --user ${username}:${password} ${hostname}${btendpoint} -F file=@${bt_file_path} ${proxy_details})

    if [[ "$bt_response" == *"200"* ]]; then
        echo ""
        echo "*********************************************************************"
        echo "ConfigMyApp created Business transaction detection rules successfully."
        echo "Please check $appName detection rule configuration pages."
        echo "*********************************************************************"
        echo ""
    else
        msg="An Error occured whilst creating business transaction detection rules. Please refer to the error.log file for further details"
        echo "${dt} An Error occured whilst creating business transaction detection rules." >>error.log
        echo "${dt} ERROR $bt_response" >>error.log
        echo "$msg"
        echo "$bt_response"
        echo ""
        sleep 1
    fi
else
    echo "$bt_file_path does not exist"
    echo ""
    echo "Business transactions will not be configured"
    echo ""
fi
