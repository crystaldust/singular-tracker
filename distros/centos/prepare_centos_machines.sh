#!/bin/bash
baseSubnet=192.168.43
function cloneVM() {
	isMaster=$1
	dstName=$2
	ipTail=$3
	hostname=$4

	if [ "$isMaster" = false ]; then
		echo "clone centos-min-base to node " $dstName " with ip: $baseSubnet."$ipTail
	else
		echo "clone centos-min-base to master " $dstName " with ip: $baseSubnet."$ipTail
	fi


	vboxmanage clonevm 'centos-min-base' --mode 'all' --name $dstName
	vboxmanage registervm /var/vms/virtual-boxes/${dstName}/${dstName}.vbox
	vboxmanage startvm --type headless $dstName

	while true; do ping -c1 $baseSubnet.80 > /dev/null && break; done
	sleep 10

	ssh root@$baseSubnet.80 "echo $hostname > /etc/hostname"

	if [ "$isMaster" = false ]; then
		ssh root@$baseSubnet.80 "sed -i s/80/$ipTail/ /etc/sysconfig/network-scripts/ifcfg-enp0s3"

		# ssh root@$baseSubnet.80 "systemctl restart network" &
		# echo "network reconfigured to $baseSubnet.$ipTail"

		echo "reboot"
		ssh root@$baseSubnet.80 'reboot'
		sleep 20
	fi

	# echo "reboot"
	# ssh root@$baseSubnet.80 'reboot'
}

cloneVM false "node1-centosmin" "81" "worker1"
cloneVM false "node2-centosmin" "82" "worker2"
# sleep 10
cloneVM true "master-centosmin" "80" "master"

sed /$baseSubnet/d ~/.ssh/known_hosts
