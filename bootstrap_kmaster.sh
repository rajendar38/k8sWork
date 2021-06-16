#!/bin/bash
echo "[TASK 0] Pull required containers"
kubeadm config images pull >/dev/null 2>&1

echo "[TASK 1] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=172.16.16.100 --pod-network-cidr=192.168.0.0/16

echo "[TASK 2] Deploy Calico network"
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml
echo "[TASK 3] Cluster join command"
kubeadm token create --print-join-command > /joincluster.sh 2>/dev/null

echo "[TASK 4] run kubectl commands as non-root user, then as a non-root user perform these"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config




