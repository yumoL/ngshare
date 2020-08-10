#!/bin/bash
eval $(minikube docker-env)
docker build -t ngshare:grades1.3 .
eval $(minikube docker-env -u)
helm package helmchart/ngshare 
cp ngshare-0.0.1-set.by.chartpress.tgz ../big-data-platforms