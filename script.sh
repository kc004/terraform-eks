#!/bin/bash
sleep 10
/usr/bin/curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2020-11-02/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && echo export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
/usr/bin/curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
/usr/bin/curl -L https://github.com/kubernetes/kompose/releases/download/v1.21.0/kompose-linux-amd64 -o kompose
chmod +x kompose
sudo cp ./kompose /usr/local/bin/kompose
KUBECONFIG=./kubeconfig_eks-test kubectl get nodes
/usr/local/bin/helm repo add hashicorp https://helm.releases.hashicorp.com
/usr/local/bin/helm install -f ./consul-values.yaml hashicorp hashicorp/consul
