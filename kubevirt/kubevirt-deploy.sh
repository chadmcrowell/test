#!/bin/bash

# deploy the KubeVirt operator
export VERSION=$(curl -s https://api.github.com/repos/kubevirt/kubevirt/releases | grep tag_name | grep -v -- '-rc' | sort -r | head -1 | awk -F': ' '{print $2}' | sed 's/,//' | xargs)
echo $VERSION
kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/kubevirt-operator.yaml

# deploy the KubeVirt custom resource definitions
kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/kubevirt-cr.yaml

# check for deployed status
kubectl get all -n kubevirt

# deploy the latest release of CDI using its Operator
export VERSION=$(curl -s https://github.com/kubevirt/containerized-data-importer/releases/latest | grep -o "v[0-9]\.[0-9]*\.[0-9]*")
kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-operator.yaml
kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-cr.yaml

# check for deployed status
kubectl get cdi cdi -n cdi

# check pods
kubectl get pods -n cdi

# create pvc
cat <<EOF > pvc_fedora.yml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: "fedora"
  labels:
    app: containerized-data-importer
  annotations:
    cdi.kubevirt.io/storage.import.endpoint: "https://download.fedoraproject.org/pub/fedora/linux/releases/33/Cloud/x86_64/images/Fedora-Cloud-Base-33-1.2.x86_64.raw.xz"
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
EOF

kubectl create -f pvc_fedora.yml

# get pvc
kubectl get pvc fedora -o yaml

# get vms
kubectl get vms