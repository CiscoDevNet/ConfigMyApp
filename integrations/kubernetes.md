---
sort: 20
---
<p><img align="right" width="200" height="57" src="https://user-images.githubusercontent.com/23483887/87779752-39f62800-c825-11ea-9c8c-66be52d131c8.png"></p>

# Kubernetes  

All files relevant for Kubernetes deployment can be found in `/kubernetes` directory of the project.

## Updating secrets and environment variables

1. Update the password in the `cma-pass-secret.yml` with your controller's user password base64 encoded.

2. Update environment variables defined in a file `cma-configmap.yaml`.

3. In a pod definition that you pick, for example, `cma-pod-standard.yml`, set the `env:` section to reflect your application and/or controller settings.

## Create a Pod

Example command of how to create the Pod:

```
kubectl apply -f <pod-manifest.yaml>
```

You can use some of the available Pod specifications, currently available are:
- `cma-pod-standard.yml` - standard deployment, without Business Transactions and Branding,
- `cma-pod-bt-volume.yml` - includes Business Transactions from `bt-config.yml` file,
- `cma-pod-branding-volume.yml` - mounts a volume for Branding feature.

Verify that the ConfigMyApp container is running:

```
kubectl get pod <pod-name>
```

Due to the short lived life span of ConfigMyApp, you may consider running it as a Kubernetes job. 
