#!/bin/bash

## !IMPORTANT ##
#
## This script is tested only in the generic/ubuntu2004 Vagrant box
## If you use a different version of Ubuntu or a different Ubuntu Vagrant box test this again
#

echo "[task 1.1]Disable Firewall"

systemctl disable firewalld; systemctl stop firewalld

echo "[task 1.2]Disable swap"
swapoff -a; sed -i '/swap/d' /etc/fstab


echo "[task 1.3]Disable SELinux"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
echo "[task 1.4]Update sysctl settings for Kubernetes networking"
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

echo "[task 1.5]install docker engine"

yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce-19.03.12 
systemctl enable --now docker

echo "[task 1.5]  k8s setup add yum repo"


cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

echo "[task 1.6]   install k8s components"

yum install -y kubeadm-1.18.5-0 kubelet-1.18.5-0 kubectl-1.18.5-0
echo "[task 1.7]   Enable and Start kubelet service"
systemctl enable --now kubelet




echo "[TASK 8] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
systemctl reload sshd

echo "[TASK 9] Set root password"
echo -e "kubeadmin\nkubeadmin" | passwd root >/dev/null 2>&1
echo "export TERM=xterm" >> /etc/bash.bashrc

echo "[TASK 10] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
172.16.16.100   kmastercent.example.com     kmastercent
172.16.16.101   kworkercent1.example.com    kworkercent1
EOF