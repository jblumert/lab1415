#!/bin/bash
oc get policyassignment  -n ibm-spectrum-fusion-ns
oc -n ibm-spectrum-fusion-ns patch policyassignment app00-monthly-apps --type merge -p '{"spec":{"recipe":{"name":"hook-recipe00", "namespace":"ibm-spectrum-fusion-ns", "apiVersion":"spp-data-protection.isf.ibm.com/v1alpha1"}}}'
