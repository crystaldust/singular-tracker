#!/bin/bash
./prepare_vb_machines.sh
./deploy_k8s.sh
./create-service.sh
./test-nginx-ds.sh
