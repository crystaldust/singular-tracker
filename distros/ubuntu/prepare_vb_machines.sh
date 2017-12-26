#!/bin/bash
function cloneVM() {
	isMaster=$1
	dstName=$2
	ipTail=$3

	if [ "$isMaster" = false ]; then
		echo "clone ubuntu-base to node " $dstName " with ip: 192.168.43." $ipTail
	else
		echo "clone ubuntu-base to master " $dstName " with ip: 192.168.43." $ipTail
	fi


	vboxmanage clonevm 'ubuntu-base' --mode 'all' --name $dstName
	vboxmanage registervm /var/vms/virtual-boxes/${dstName}/${dstName}.vbox
	vboxmanage startvm --type headless $dstName

	while true; do ping -c1 192.168.43.90 > /dev/null && break; done
	sleep 10

	if [ "$isMaster" = false ]; then
		ssh root@192.168.43.90 "sed -i s/90/$ipTail/ /etc/network/interfaces"
	fi
	echo "reboot"
	ssh root@192.168.43.90 'reboot'
	sleep 20
}

cloneVM false "node1-ubuntux" "91"
cloneVM false "node2-ubuntux" "92"
sleep 10
cloneVM true "master-ubuntux"

sed /192.168.43/d ~/.ssh/known_hosts
