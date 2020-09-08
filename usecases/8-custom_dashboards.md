---
sort: 8

---
# Upload Custom Dashboards

ConfigMyApp comes with an out-of-the-box dynamic dashboard template. click <a href="https://appdynamics.github.io/ConfigMyApp/introduction/5-sample-output.html" target="_blank"> here </a> to see what it looks like.

If the out of the box dashboard does not meet your requirements, you may use ConfigMyApp to upload custom dashboards. Use the following steps:  

1. Create the custom dashboard in the controller.
2. Export the file to your local machine.
3. Using your favourite text editor, find and replace the business application name with 'ChangeApplicationName'. Please note that it is case sensitive.
4. Copy the modified json file into the `custom_dashboard` folder  
5. Repeat the steps above for all the custom dashboards you will like to create per application. 

```tip
ConfigMyApp can process multiple custom dashboards from the `custom_dashboards` folder. 
```

<b> Runtime parameters</b>

The run time parameter is `--upload-custom-dashboard` and it defaults to false. For example: 

`./start.sh -c http://appd.saas.com -a MyApp --username=appd --password=appd --upload-custom-dashboard`


<b>Environment variables</b>

`CMA_UPLOAD_CUSTOM_DASHBOARD=true`

<b>Configuration file (`config.json`)</b>

`
"configuration": [
    {
      [truncated]
      "upload_custom_dashboard": false
    }
  ],
`