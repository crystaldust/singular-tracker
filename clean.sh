#!/bin/bash
scp ./clean.master.sh root@192.168.43.80:/root/
scp ./clean.node.sh root@192.168.43.81:/root/
scp ./clean.node.sh root@192.168.43.82:/root/

ssh root@192.168.43.80 'chmod +x /root/clean.master.sh'
ssh root@192.168.43.81 'chmod +x /root/clean.node.sh'
ssh root@192.168.43.82 'chmod +x /root/clean.node.sh'


ssh root@192.168.43.80 '/root/clean.master.sh'
ssh root@192.168.43.81 '/root/clean.node.sh'
ssh root@192.168.43.82 '/root/clean.node.sh'
