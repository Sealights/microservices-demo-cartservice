﻿#!/bin/bash
kubectl delete deployment cartservice
kubectl delete svc cartservice
kubectl create -f manifest.yaml