#!/bin/bash
function cloneVM() {
	isMaster=$1
	dstName=$2
	ipTail=$3
	hostname=$4

	if [ "$isMaster" = false ]; then
		echo "clone archlinux-base to node " $dstName " with ip: 192.168.43."$ipTail
	else
		echo "clone archlinux-base to master " $dstName " with ip: 192.168.43."$ipTail
	fi


	vboxmanage clonevm 'archlinux-base' --mode 'all' --name $dstName
	vboxmanage registervm /var/vms/virtual-boxes/${dstName}/${dstName}.vbox
	vboxmanage startvm --type headless $dstName

	sleep 10
	while true; do ping -c1 192.168.43.70 > /dev/null && break; done
	# sleep 3

	ssh root@192.168.43.70 "hostnamectl set-hostname $hostname"
	if [ "$isMaster" = false ]; then
		ssh root@192.168.43.70 "sed -i s/70/$ipTail/ /etc/netctl/enp0s3"
		echo "restart network"
		ssh root@192.168.43.70 'netctl restart enp0s3' &
	fi
}

cloneVM false "node1-archlinux" "71" "worker1"
cloneVM false "node2-archlinux" "72" "worker2"
cloneVM true "master-archlinux" "" "master"

sed /192.168.43/d ~/.ssh/known_hosts

ping -c1 192.168.43.70
ping -c1 192.168.43.71
ping -c1 192.168.43.72
