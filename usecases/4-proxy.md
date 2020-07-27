---
sort: 4
---

# Proxy Settings

If your AppDynamics controller is behind a proxy, ConfigMyApp lets you specify the Proxy Host and Port. Proxy authentication is not supported. 

<b> Runtime parameters</b>

`./start.sh -c http://appd-cx.com -a API_Gateway -u appd -p appd --use-proxy 	--proxy-url="10.3.5.9" --proxy-port 8080`

<b>Environment variables</b>

```
CMA_USE_PROXY=true
CMA_PROXY_URL=10.5.9.1
CMA_PROXY_PORT=4993

```

<b>Configuration file (`config.json`)</b>

```json
    "controller_details": [
      {
        [truncated]
        "use_proxy": true,
        "proxy_url": "127.0.0.1",
        "proxy_port": "8030" 
      }
    ]
  
 ```
