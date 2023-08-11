#!/bin/bash
oc get secret/pull-secret -n openshift-config -ojson | \
jq -r '.data[".dockerconfigjson"]' | \
base64 -d | \
jq '.[]."cp.icr.io" += input' - authority.json > temp_config.json

oc set data secret/pull-secret -n openshift-config --from-file=.dockerconfigjson=temp_config.json

oc get secret/pull-secret -n openshift-config -ojson | \
jq -r '.data[".dockerconfigjson"]' | \
base64 -d

rm temp_config.json
