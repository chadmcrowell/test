# initialize the cluster
# sudo rm /root/.kube/config
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# set config and permissions
mkdir -p ~/.kube
sudo cp -i /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# apply flannel cni
kubectl apply -f ${HOME}/flannel.yaml
sudo rm ${HOME}/flannel.yaml

echo
echo "### COPY AND PASTE THIS IN THE WORKER NODE ###"
sudo kubeadm token create --print-join-command --ttl 0