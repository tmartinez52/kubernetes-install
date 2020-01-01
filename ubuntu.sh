#!/bin/bash
KUBERNETESGPG=https://packages.cloud.google.com/apt/doc/apt-key.gpg
DOCKERGPG=https://download.docker.com/linux/ubuntu/gpg
FINGERPRINT=0EBFCD88
Using variables for script

apt-get update

apt-get install -y \
apt-transport-https \
ca-certifications \
curl \
software-properties-common \ 

curl -s $KUBERNETESGPG | apt-key add -

curl -fsSL $DOCKERGPG | sudo apt-key add -

#dir /etc/apt/sources.list.d/kubernetes.list
cat > /etc/apt/sources.list.d/kubernetes.list <<EOF
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

sudo apt-key fingerprint $FINGERPRINT
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu disco stable" 

sudo apt install docker-ce -y

cat > /etc/docker/daemon.json <<EOF
{
"exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts": {
  "max-size": "100m"
},
"storage-driver": "overlay2"
}
EOF

systemctl restart docker

sudo swapoff -a

##Clearing VARIABLES
unset FINGERPRINT
unset KUBERNETESGPG
unset DOCKERGPG
