#!/bin/bash

kubectl delete deployment b-cartservice
kubectl create -f manifest-pod.yaml