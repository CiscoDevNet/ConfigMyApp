---
sort: 5

---

# Encode Password

## Secret Managers 

ConfigMyApp is primarily designed to be executed from CI/CD tools, on this basis, we recommend that you utilise existing secret manager tools/plugins to securely store the service account password. 

## Based64 Encode

We decided not to add password encryption capabilites to ConfigMyApp as that would introduce dependencies (OpenSSL for example) that does not exist in CI/CD tools by default. As a result, we added the ability to encode the password instead. 

For added security, ConfigMyApp supports base64 password encoding. For example: 

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
