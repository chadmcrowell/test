#!/bin/bash

cd && helm create kubevirt-vms && cd kubevirt-vms

rm -rf ~/kubevirt-vms/templates/tests
rm ~/kubevirt-vms/values.yaml

cd templates && rm deployment.yaml hpa.yaml ingress.yaml service.yaml serviceaccount.yaml NOTES.txt

cp ~/test/helm/vms.yml .
cp ~/test/helm/values.yaml ~/kubevirt-vms/
cp ~/test/helm/pv.yml . && cd ~/kubevirt-vms

# install chart
helm install kubevirt-vms . -f values.yaml

# list the rev
helm list

# get the output from the chart
helm template kubevirt-vms .

# update the chart according to new values
helm upgrade kubevirt-vms . -f values.yaml