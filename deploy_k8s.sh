#!/bin/bash

# wait for the 3 nodes to be ready
if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters, please specify {template_path} and {subnet_pattern}"
	exit 1
fi

template_path=$1
subnet_pattern=$2 # something like "43.7"

function waitForHost {
	host=$1
	echo waiting for $host
	while true; do ping -c1 $host > /dev/null && break; done
}

waitForHost "192.168.${subnet_pattern}0"
waitForHost "192.168.${subnet_pattern}1"
waitForHost "192.168.${subnet_pattern}2"
# wait

start=$(($(date +%s%N)/1000000))
singular deploy template $template_path --db true --config ~/.containerops/confs/singular.toml --verbose
end=$(($(date +%s%N)/1000000))
elapsed=$(($end - $start))
echo "${elapsed} for kubernetes deployment"

# Add the insecure registry to all the nodes
function addInsecureRegistry {
	host=$1
	ssh root@$1 "sed -i s/DOCKER_NETWORK_OPTIONS/DOCKER_NETWORK_OPTIONS\ --insecure-registry=192.168.43.156:8990/ /etc/systemd/system/docker.service"
	ssh root@$1 "systemctl daemon-reload"
	ssh root@$1 "systemctl restart docker"
}

addInsecureRegistry "192.168.${subnet_pattern}0"
addInsecureRegistry "192.168.${subnet_pattern}1"
addInsecureRegistry "192.168.${subnet_pattern}2"

deploy_folder=$(cat $template_path | head -1 | awk '{print $2}')
cp ~/.containerops/singular/$deploy_folder/0/kubectl/config ~/.kube/
# cp ~/.containerops/singular/containerops/singular/etcd-3.2.8-flanneld-0.7.1-docker-17.04.0-ce-k8s-1.7.0/0/kubectl/config ~/.kube/
