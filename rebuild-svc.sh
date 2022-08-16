#!/bin/bash

kubectl delete svc b-cartservice
kubectl create -f manifest-svc.yaml
