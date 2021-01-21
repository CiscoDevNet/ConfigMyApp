---
sort: 9

---
# Upload Default Dashboards

ConfigMyApp comes with an out-of-the-box dynamic dashboard template. click <a href="https://appdynamics.github.io/ConfigMyApp/introduction/5-sample-output.html" target="_blank"> here </a> to see what it looks like.

<b> Runtime parameters</b>

The run time parameter is `--upload-default-dashboard` / `--no-upload-default-dashboard` and it defaults to `true`. For example: 

`./start.sh -c http://appd.saas.com -a MyApp --username=appd --password=appd --upload-default-dashboard`

<b>Environment variables</b>

`CMA_UPLOAD_DEFAULT_DASHBOARD=true`

<b>Configuration file (`config.json`)</b>

```
"configuration": [ 
    {
      [truncated]
      "upload_default_dashboard": true
    }
  ],

```
