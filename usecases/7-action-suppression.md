---
sort: 7

---
# Action Suppression

You configure action suppression for a specific time period to apply to a specific object or several objects. The following entities can be the objects of action suppression:

- Application
- Business Transaction
- Tier
- Node
- JMX
- Machine

Within the time period configured for the action suppression, no policy actions are fired for health rule violation events that occur on the specified object(s).

Please refer to the <a href="https://docs.appdynamics.com/display/PRO45/Action+Suppression+API"> Action Suppression API</a> documentation for further details. 

<b> Runtime parameters</b>

If not specified, `--suppress-start` value defaults to current date and time, and `--suppress-duration` defaults to 60 minutes:

`./start.sh -c http://appd.saas.com -a MyApp --username=appd --password=appd --suppress-action`

These values can be explicitly set as well: 

`./start.sh -c http://appd.saas.com -a MyApp --username=appd --password=appd --suppress-action --suppress-start=2020-01-31T12:00:00+0000 --suppress-duration=120`

For `--suppress-start` use GMT timezone.

Use `--help` option for more details on format, timezone and default values.

In case that only files from a folder that contains action suppression API payload should be imported to the controller, use `--suppress-upload-files` parameter:

`./start.sh -c http://appd.saas.com -a MyApp --username=appd --password=appd --suppress-upload-files`

By setting this flag the only action that is going to be performed is uploading action suppression files, no other configuration is going to be sent to controller. Place your JSON files to the folder: `./api_actions/actions/`.

<b>Environment variables</b>

`CMA_SUPPRESS_ACTION=true`
`CMA_SUPPRESS_START=2020-01-31T12:00:00+0000`
`CMA_SUPPRESS_DURATION=120`

`CMA_SUPPRESS_UPLOAD_FILES=true`

<b>Configuration file (`config.json`)</b>

`"suppress_action": false`
`"suppress_start": "2020-01-31T12:00:00+0000"`
`"suppress_duration": "120"`
`"suppress_upload_files": false`


