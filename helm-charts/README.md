# Helm

Helm Charts help you define, install, and upgrade even the most complex Kubernetes application. Charts are easy to create, version, share, and publish — so start using Helm and stop the copy-and-paste.

### This Helm Charts deploy the following resources:
- Ingress NGINX controller. Used AWS NLB as external load balancer (check values.yaml file). 
- Application resources like deployment, service, ingress
- Website with domain name http://webserver.networkthor.info


### Structure of repo:
- ingress-nginx  -  charts to deploy ingress NGINX controller
- webserver      -  charts to deploy application resources
- templates      -  helm templates which used to generate custom application resources
- values.yaml    -  default values

## Steps:

1.	Clone this repo to your local machine
2.	Install Helm for your local machine. Use this repository https://helm.sh/docs/intro/install/
3.	Update local kubeconfig
4.  Run helm commands (commands section)


⚠️ **IMPORTANT** 

```
At first you need to deploy ingress-controller resources and then deploy application resources.
```

⚠️ **IMPORTANT** 

```
Our application need client source IP to retrive geolocation. By default, kubernetes will hide real source IP, therefore we need to configure proxy protocol.
```


## Commands
### Deploy Ingress Controller:
Prepare configmap for proxy protocol:
```
data:
  use-proxy-protocol: "true"
  real-ip-header: "proxy_protocol"

```
Prepare ingress service for proxy protocol:
```
metadata:
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-target-group-attributes: proxy_protocol_v2.enabled=true

```
Apply helm:
```
helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --version 4.4.2 --values values.yaml --create-namespace

```
### Deploy application resources:
Prepare values file for using custom index html directory and environment variables:
```
volumeMounts:
    mountPath: /usr/src/app/html/
  env:
    name: ENV_STAGE
    value: "production"

```
Apply helm:
```
helm install webserver webserver/ --namespace webserver --create-namespace

```


### Check application:

```
curl http://webserver.networkthor.info/
curl http://webserver.networkthor.info/index.html

```