---
sort: 3
---

# Branding

ConfigMyApp uses the `logo.png` and the `background.jpg` file in the `branding` folder by default. We recommend that you replace both files with your company's images. Alternatively, you may add more images into the `branding` folder and specify the image names as extra parameters. See examples below: 

<b> Runtime Paramaters</b>

`./start.sh -c http://appd-cx.com -a API_Gateway -u appd -p appd --use-branding --logo-name="logo-white.png" --background-name="appd-bg.jpg"`

<b>Environment variables</b>

```
CMA_USE_BRANDING=true
CMA_BACKGROUND_NAME=<bg_image_name>.<file-extension>
CMA_LOGO_NAME=<logo_image_name>.<file-extension>

```

<b>Configuration file (`config.json`)</b>

```json
   "branding": [
      {
        "enabled": true,
        "logo_file_name": "logo.png",
        "background_file_name": "background.jpg"
      }
    ]
```