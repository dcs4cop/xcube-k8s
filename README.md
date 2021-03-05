# xcube-k8s
This repository contains Kubernetes helm Charts to configure xcube generation services as well as
xcube geoDB:

- [geoDB](https://github.com/dcs4cop/xcube-geodb)
- [xcube-hub](https://github.com/bcdev/xcube-hub)

You can install the services using the following helm commands:

__geoDB__:
```bash
helm upgrade --install xcube-geodb --repo https://dcs4cop.github.io/xcube-k8s  xcube-geodb  -f values.yaml  --version 0.1.6
```

__xcube-hub__:
```bash
helm upgrade --install xcube-gen --repo https://dcs4cop.github.io/xcube-k8s  xcube-gen  -f values.yaml  --version 1.2.0
```

In order to get this running you need to specify a values.yaml file. The following lines are an example how such 
a configuration looks like for xcube-gen

```yaml
# Default values for xcube-gen.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

##############################################
## GLOBAL
##############################################

default:
  - &xcube-gen-host xcube-gen.***
  - &xcube-gen-host-url https://xcube-gen.***
  - &xcube-gen-host-api-url https://stage.***/api/v2
  - &xcube-gen-host-callback-url https://stage.***/api/v2
  - &webapi-repository quay.io/bcdev/xcube-hub
  - &webapi-tag "v2.0.0"
  - &webui-repository quay.io/bcdev/xcube-gen-ui
  - &webui-tag "1.1.0-dev.4.3"
  - &xcube-webapi-repository quay.io/bcdev/xcube-gen:0.7.0
  - &xcube-gen-namespace xcube-gen-stage
  - &sh_client_id '***'
  - &sh_client_secret '***'
  - &sh_instance_id '***'
  - &aws_access_key_id '***'
  - &aws_secret_access_key '***' 
  - &xcube_hub_token_secret = '***'

serviceAccount:
  name: xcube-gen-stage

webapiContainer:
  name: webapi
  namespace: *xcube-gen-namespace
  repository: *webapi-repository
  tag: *webapi-tag
  pullPolicy: Always # Use Always for development
  port: 8080
  replicaCount: 1
  rollme: 1
  resources: {}
  securityContext:
    fsGroup: 100
    runAsUser: 1000
  xcubeGenImage: *xcube-webapi-repository
  volumes:
    - name: xcube-datapools
      configMap:
        name: xcube-datapools
    - name: xcube-openapi
      configMap:
        name: xcube-openapi
  volumeMounts:
    - name: xcube-datapools
      mountPath: "/etc/xcube"
      readOnly: true
    - name: xcube-openapi
      mountPath: "/etc/xcube-hub"
      readOnly: true
  env:
    - name: SH_CLIENT_ID
      value: *sh_client_id
    - name: SH_CLIENT_SECRET
      value: *sh_client_secret
    - name: SH_INSTANCE_ID
      value: *sh_instance_id
    - name: AWS_ACCESS_KEY_ID
      value: *aws_access_key_id
    - name: AWS_SECRET_ACCESS_KEY
      value: *aws_access_key_id
    - name: XCUBE_DOCKER_IMG
      value: *xcube-webapi-repository
    - name: XCUBE_DOCKER_WEBAPI_IMG
      value: *xcube-webapi-repository
    - name: XCUBE_HUB_CALLBACK_URL
      value: *xcube-gen-host-callback-url
    - name: XCUBE_HUB_DOCKER_PULL_POLICY
      value: Always
    - name: XCUBE_HUB_CACHE_PROVIDER
      value: redis
    - name: XCUBE_HUB_REDIS_HOST
      value: xcube-gen-stage-redis
    - name: XCUBE_WEBAPI_URI
      value: *xcube-gen-host-url
    - name: XCUBE_HUB_PROCESS_LIMIT
      value: 10000
    - name: XCUBE_HUB_TOKEN_SECRET
      value: *xcube_hub_token_secret
    - name: XCUBE_HUB_OAUTH_AUD
      value: 'https://xcube-gen.brockmann-consult.de/api/v2/'
    - name: XCUBE_GEN_API_CALLBACK_URL
      value: *xcube-gen-host-api-url
    - name: XCUBE_GEN_DATA_POOLS_PATH
      value: "/etc/xcube/data-pools.yaml"
    - name: XCUBE_HUB_OAUTH_USER_MANAGEMENT_AUD
      value: 'https://edc.eu.auth0.com/api/v2/'
    - name: K8S_NAMESPACE
      value: *xcube-gen-namespace


uiContainer:
  name: ui
  create: false
  repository: *webui-repository
  tag: *webui-tag
  # pullPolicy: IfNotPresent # Use Always fo r development
  pullPolicy: Always # Use Always for development
  port: 80
  replicaCount: 1
  resources: {}
  rollme: 0
  env:
    - name: K8S_NAMESPACE
      value: *xcube-gen-namespace
    - name: REACT_APP_API_SERVER_URL
      value: *xcube-gen-host-url


keycloakContainer:
  spawn: false


##############################################
## Ingress
##############################################

ingress:
  enabled: true
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: "2000m"
  hosts:
    - host: *xcube-gen-host
      paths:
        - path: /api/v2/
          servicePort: 8080
          serviceNameSuffix: 'webapi'
  tls: []


```

In order to get this running you need to specify a values.yaml file. The following lines are an example how such
a configuration looks like for the xcube-geodb service.

```yaml
# Default values for xcube-gen.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

##############################################
## GLOBAL
##############################################

defaults:
  - &xcube-geodb-host stage.xcube-geodb.brockmann-consult.de

namespace: xcube-geodb

webservices:
  - name: postgrest
    repository: quay.io/bcdev/xcube-geodb-postgrest
    replicaCount: 1
    secretName: postgrest
    secretMountPath: /postgrest
    pullPolicy: Always
    port: 3000
    servicePort: 3000
    probes: 0
    resources:
      requests:
        memory: "1Gi"
        cpu: "125m"
      limits:
        memory: "4Gi"
        cpu: "500m"


##############################################
## Ingress
##############################################

ingress:
  enabled: true
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$1
    nginx.ingress.kubernetes.io/proxy-body-size: "2000m"
  hosts:
    - host: *xcube-geodb-host
      paths:
        - path: /(.*)
          servicePort: 3000
          serviceNameSuffix: 'postgrest'
  tls: []

```

