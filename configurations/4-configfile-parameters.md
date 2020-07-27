---
sort: 4
---

# Configuration file

ConfigMyApp uses a `config.json` configuration file which can be found in the root of the project.

The values in the configuration file are only used when the runtime parameter is not defined and the environment for the same parameter does not exist.

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
