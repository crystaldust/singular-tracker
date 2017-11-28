#!/bin/bash
kubectl delete pods $(kubectl get pods | grep -i nginx | awk '{print $1}')
kubectl delete svc nginx-ds
kubectl delete ds nginx-ds

kubectl create -f nginx-ds.yml

kubectl get pods -o wide
kubectl get svc
