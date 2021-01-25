# Changes in Version 1.1
## New Features
- Added a configmap allowing data-pools to be configured to be used by
  the datastore-crontab.
- The data pools config map uses cfgs/data-pools.yaml

## Fixes
- The ingress is now using the correct api version when the kubernetes version is >=20
- The redis container config map now uses a proper name
- Cleaned .gitignore

## Changes in Version 1.0.1

- Added a keycloak instance
- Added a cronjob to get datastore info
- Added a xcube- webapis stage cluster config
- Added a keycloak template
- Shifted cluster configs from root dir to app dir
- Fixed persistentVolumeClaim. The correct volume mount does now appear in the xcube-gen webapi container
