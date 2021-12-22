#!/bin/bash

# deploy the KubeVirt operator
# https://kubevirt.io/quickstart_cloud/
export VERSION=$(curl -s https://api.github.com/repos/kubevirt/kubevirt/releases | grep tag_name | grep -v -- '-rc' | sort -r | head -1 | awk -F': ' '{print $2}' | sed 's/,//' | xargs)
echo $VERSION
kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/kubevirt-operator.yaml

# deploy the KubeVirt custom resource definitions
kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/kubevirt-cr.yaml

# check for deployed status
kubectl get all -n kubevirt

# deploy the latest release of Containerized Data Importer(CDI) using its Operator
# https://github.com/kubevirt/containerized-data-importer#deploy-it
export VERSION=$(curl -s https://github.com/kubevirt/containerized-data-importer/releases/latest | grep -o "v[0-9]\.[0-9]*\.[0-9]*")
kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-operator.yaml
kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-cr.yaml

# enable dv feature gate
# https://kubevirt.io/2018/CDI-DataVolumes.html
kubectl create configmap kubevirt-config --from-literal feature-gates=DataVolumes -n kube-system

# check for deployed status
kubectl get cdi cdi -n cdi

# check pods
kubectl get pods -n cdi

# install virtctl 
VERSION=$(kubectl get kubevirt.kubevirt.io/kubevirt -n kubevirt -o=jsonpath="{.status.observedKubeVirtVersion}")
ARCH=$(uname -s | tr A-Z a-z)-$(uname -m | sed 's/x86_64/amd64/') || windows-amd64.exe
echo ${ARCH}
curl -L -o virtctl https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/virtctl-${VERSION}-${ARCH}
chmod +x virtctl
sudo install virtctl /usr/local/bin

# create pvc
cat <<EOF > pv.yml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: data-pv
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"
EOF
kubectl create -f pv.yml

# get pv
kubectl get pv

# create vm
kubectl apply -f ~/test/kubevirt/alpine-vm.yml

# start vm
virtctl start vm-alpine-datavolume

# watch the vm get scheduled
kubectl get vmi -w

# get vms
kubectl get vm

# get dataVolume
kubetl get dv