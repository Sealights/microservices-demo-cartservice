#!/bin/bash
kubectl delete deployment b-cartservice
kubectl delete svc b-cartservice
kubectl create -f b-manifest.yaml