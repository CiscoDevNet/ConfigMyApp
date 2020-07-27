---
sort: 15

---

# Encoded Password  

For added security, ConfigMyApp supports base64 password encoding. For example 

`echo "password" | base64` outputs  `YXBwZAo=` 

which can be used in ConfigMyApp instead of the plain text `password`

<b> Run time Paramaters</b>

`./start.sh -c http://appd.saas.com -a MyApp -u appd -p YXBwZAo=  --use-encoded-credentials`

<b>Environment variables</b>

```
CMA_PASSWORD=YXBwZAo=
CMA_USE_ENCODED_CREDENTIALS=true
```
<b>Configuration file (`config.json`)</b>

` "are_passwords_encoded": true`
