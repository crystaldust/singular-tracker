#!/bin/bash

# wait for the 3 nodes to be ready

function waitForHost {
	host=$1
	echo waiting for $host
	while true; do ping -c1 $host > /dev/null && break; done
}

waitForHost '192.168.43.90'
waitForHost '192.168.43.91'
waitForHost '192.168.43.92'
# wait

singular deploy template ./template-vm.yml  --config ~/.containerops/confs/singular.toml

# Add the insecure registry to all the nodes
function addInsecureRegistry {
	host=$1
	ssh root@$1 "sed -i s/DOCKER_NETWORK_OPTIONS/DOCKER_NETWORK_OPTIONS\ --insecure-registry=192.168.43.156:8990/ /etc/systemd/system/docker.service"
	ssh root@$1 "systemctl daemon-reload"
	ssh root@$1 "systemctl restart docker"
}

addInsecureRegistry '192.168.43.90'
addInsecureRegistry '192.168.43.91'
addInsecureRegistry '192.168.43.92'

cp ~/.containerops/singular/containerops/singular/etcd-3.2.8-flanneld-0.7.1-docker-17.04.0-ce-k8s-1.7.0/0/kubectl/config ~/.kube/