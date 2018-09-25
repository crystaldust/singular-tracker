#!/bin/bash
delete_bins() {
	bins=$1
	for item in "${bins[@]}"
	do
		rm -f /usr/local/bin/$item &
	done
	wait
}

# stop systemd services
systemctl stop docker
systemctl stop flanneld
systemctl stop etcd
systemctl stop kube-apiserver.service
systemctl stop kube-controller-manager.service
systemctl stop kube-scheduler.service
systemctl stop kube-proxy.service
systemctl stop kubelet.service

# remove systemd service files
rm -rf /etc/systemd/system/docker*
rm -rf /etc/systemd/system/kube-*
rm -rf /etc/systemd/system/flanneld.service
rm -rf /etc/systemd/system/etcd.service
rm -f /etc/systemd/system/kube-proxy.service
rm -f /etc/systemd/system/kubelet.service

# remove etcd data folder
rm -rf /var/lib/etcd

# remove binaries
docker_bins=(docker docker-containerd docker-containerd-ctr docker-continerd-shim docker-init docker-proxy docker-runc dockerd)
etcd_bins=(etcd etcdctl)
flanneld_bins=(flanneld mk-docker-opts.sh)
kube_bins=(kube-apiserver kube-controller-manager kube-proxy kube-scheduler kubectl kubelet)

delete_bins $docker_bins
delete_bins $etcd_bins
delete_bins $flanneld_bins
delete_bins $kube_bins


# remove configs
rm -rf /etc/kubernetes
rm -rf /etc/flanneld
rm -rf /etc/etcd

ip link del flannel.1
ip link del docker0
