#!/bin/bash
echo "copying scripts"
subnet_pattern=$1
scp ./clean.master.sh root@192.168.${subnet_pattern}0:/root/ &
scp ./clean.node.sh root@192.168.${subnet_pattern}1:/root/ &
scp ./clean.node.sh root@192.168.${subnet_pattern}2:/root/ &
wait

echo "add exec permission"
ssh root@192.168.${subnet_pattern}0 'chmod +x /root/clean.master.sh' &
ssh root@192.168.${subnet_pattern}1 'chmod +x /root/clean.node.sh' &
ssh root@192.168.${subnet_pattern}2 'chmod +x /root/clean.node.sh' &
wait


echo "exec cleaning scripts"
ssh root@192.168.${subnet_pattern}0 '/root/clean.master.sh' &
ssh root@192.168.${subnet_pattern}1 '/root/clean.node.sh' &
ssh root@192.168.${subnet_pattern}2 '/root/clean.node.sh' &
wait
