KUBE_VERSION=1.21.0

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# disable swapoff
sudo swapoff -a

# Update the apt package index
sudo apt-get update

# Install packages to allow apt to use a repository over HTTPS
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Set up the Docker stable repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Add Kubernetes gpg key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Add Kubernetes stable repository
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# Update the apt package index
sudo apt-get update

# Install the 19.03.4 version of Docker Engine - Community
sudo apt-get install -y containerd.io docker-ce=5:20.10.6~3-0~ubuntu-$(lsb_release -cs)

# Install kubelet, kubeadm and kubectl packages
sudo apt-get install -y kubelet=${KUBE_VERSION}-00 kubeadm=${KUBE_VERSION}-00 kubectl=${KUBE_VERSION}-00

# hold at current versions
sudo apt-mark hold kubelet kubeadm kubectl

# initialize the cluster
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# set config and permissions
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# download yaml flannel 
sudo wget -O ${HOME}/flannel.yaml "https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml"