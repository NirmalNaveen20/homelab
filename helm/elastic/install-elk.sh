#!/bin/bash

# environments
NAMESPACE="elasticsearch"
VALUES_FILE="values.yaml"

# create namespace
echo "checking the namespace: $NAMESPACE"
if ! kubectl get namespace "$NAMESPACE" &>/dev/null; then
    echo "Namespace '$NAMESPACE' not found, creating..."
    kubectl create namespace "$NAMESPACE"
else
    echo "Namespace '$NAMESPACE' already existed, passing."
fi

# Add the Elastic Helm charts repo
helm repo add elastic https://helm.elastic.co

# install elasticsearch
cd elasticsearch
helm upgrade --install elastic elastic/elasticsearch --version 8.5.1 -f $VALUES_FILE -n $NAMESPACE

# install filebeat
cd filebeat
helm upgrade --install filebeat elastic/filebeat --version 8.5.1 -f $VALUES_FILE -n $NAMESPACE

# install logstash
cd logstash
helm upgrade --install logstash elastic/logstash --version 8.5.1 -f $VALUES_FILE -n $NAMESPACE 

# install kibana
cd kibana
helm upgrade --install kibana elastic/kibana --version 8.5.1 -f $VALUES_FILE -n $NAMESPACE

# install metricbeat
cd metricbeat
helm upgrade --install metricbeat elastic/metricbeat --version 8.5.1 -f $VALUES_FILE -n $NAMESPACE

# Change Persistent Volume Claim Reclaim Policy for elasticsearch
kubectl get pv | grep Delete | awk '{print$1}' | xargs -I %  kubectl patch pv % -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}'