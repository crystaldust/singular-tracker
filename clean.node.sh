#!/bin/bash

# stop systemd services
systemctl stop docker
systemctl stop flanneld
systemctl stop etcd
systemctl stop kube-proxy.service 
systemctl stop kubelet.service 

# remove systemd service files
rm -rf /etc/systemd/system/docker*
rm -rf /etc/systemd/system/kube-*
rm -rf /etc/systemd/system/flanneld.service
rm -rf /etc/systemd/system/etcd.service
rm -f /etc/systemd/system/kube-proxy.service

# remove etcd data folder
rm -rf /var/lib/etcd

# remove binaries
rm /usr/local/bin/docker
rm /usr/local/bin/docker-containerd
rm /usr/local/bin/docker-containerd-ctr
rm /usr/local/bin/docker-containerd-shim
rm /usr/local/bin/docker-init
rm /usr/local/bin/docker-proxy
rm /usr/local/bin/docker-runc
rm /usr/local/bin/dockerd
rm /usr/local/bin/etcd
rm /usr/local/bin/etcdctl
rm /usr/local/bin/flanneld
rm /usr/local/bin/kube-apiserver
rm /usr/local/bin/kube-controller-manager
rm /usr/local/bin/kube-proxy
rm /usr/local/bin/kube-scheduler
rm /usr/local/bin/kubectl
rm /usr/local/bin/kubelet
rm /usr/local/bin/mk-docker-opts.sh

# remove configs
rm -rf /etc/kubernetes
rm -rf /etc/flanneld
rm -rf /etc/etcd

ip link del flannel.1
ip link del docker0

