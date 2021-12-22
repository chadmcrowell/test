#!/bin/bash

cd && helm create kubevirt-vms && cd kubevirt-vms

rm -rf ~/kubevirt-vms/templates/tests
rm ~/kubevirt-vms/values.yaml

cd templates && rm deployment.yaml hpa.yaml ingress.yaml service.yaml serviceaccount.yaml

cp ~/test/helm/vms1.yml .
cp ~/test/helm/vms2.yml .
cp ~/test/helm/values.yml ~/kubevirt-vms/
cp ~/test/helm/pv.yml . && cd ~/kubevirt-vms

# install chart
helm install kubevirt-vm .

# list the rev
helm list

# get the output from the chart
helm template create kubevirt-vm .

# update the chart according to new values
helm upgrade kubevirt-vm . -f values.yml