# Changes in Version 1.2.0

- webapi: Added route /api/v2 to liveness and readiness probes
- webapi: Added an initContainers config to enforce that the xcube-gen image is pulled properly prior to starting  teh service
- ui: Allows now to configure whether the ui is actually started
  -  all: simplied naming. Does not use helpers anymore
- Removed the datastore cronjob. This is now handled by the webapi service itself dynamically on-the-fly
- Changed the name of teh datapools configmap. Removed the suffix '-ci'

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
