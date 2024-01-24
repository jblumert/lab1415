#!/bin/bash

# 1. upgrade fusion on both clusters
# 2. upgrade agent on hub
# 3. remove connection on hub
# 4. remove connection on spoke
# 5. login to spoke
# 6. run attach yaml
oc login -u ocadmin -p ibmrhocp --server=https://api.ocp2.ibm.edu:6443
oc delete connection connection-feb666b0dc -n ibm-spectrum-fusion-ns
