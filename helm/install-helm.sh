#!/bin/bash

wget https://get.helm.sh/helm-v3.7.2-linux-amd64.tar.gz
tar -xvf helm-v3.7.2-linux-amd64.tar.gz
rm helm-v3.7.2-linux-amd64.tar.gz
sudo mv ./linux-amd64/helm /usr/local/bin/helm
chmod +x /usr/local/bin/helm