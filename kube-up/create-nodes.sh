#/bin/bash

# api key can be found in Settings > Preferences > Security
API_KEY=""

civo apikey add my_key $API_KEY

# create control plane 0
civo instance create --size g3.medium --diskimage ubuntu-focal --initialuser ubuntu --hostname k8s0 --wait

# output random password for k8s0 server
civo instance password k8s0

# create worker node 1
civo instance create --size g3.medium --diskimage ubuntu-focal --initialuser ubuntu --hostname k8s1 --wait

# output random password for k8s1 server
civo instance password k8s1

# create worker node 2
civo instance create --size g3.medium --diskimage ubuntu-focal --initialuser ubuntu --hostname k8s2 --wait

# output random password for k8s2 server
civo instance password k8s2

# show k8s0 public ip
civo instance show k8s0 | grep "Public IP"

# show k8s1 public ip
civo instance show k8s1 | grep "Public IP"

# show k8s2 public ip
civo instance show k8s2 | grep "Public IP"