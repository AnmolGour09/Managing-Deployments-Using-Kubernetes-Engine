



#!/bin/bash

CYAN_TEXT=$'\033[0;96m'
BOLD_TEXT=$'\033[1m'
RESET_FORMAT=$'\033[0m'


echo "${CYAN_TEXT}${BOLD_TEXT}==================================================================${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}                             Anmol Gour                           ${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}==================================================================${RESET_FORMAT}"
echo




# Fetch zone and region
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)


gcloud config set compute/zone $ZONE

gsutil -m cp -r gs://spls/gsp053/orchestrate-with-kubernetes .
cd orchestrate-with-kubernetes/kubernetes


gcloud container clusters create bootcamp \
  --machine-type e2-small \
  --num-nodes 3 \
  --scopes "https://www.googleapis.com/auth/projecthosting,storage-rw"

kubectl explain deployment

kubectl explain deployment --recursive

kubectl explain deployment.metadata.name



sed -i "s/auth:2.0.0/auth:1.0.0/" deployments/auth.yaml

kubectl create -f deployments/auth.yaml

kubectl get deployments

kubectl get replicasets

kubectl get pods

kubectl create -f services/auth.yaml

kubectl create -f deployments/hello.yaml
kubectl create -f services/hello.yaml


kubectl create secret generic tls-certs --from-file tls/
kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf
kubectl create -f deployments/frontend.yaml
kubectl create -f services/frontend.yaml

kubectl get services frontend


sed -i "s/auth:1.0.0/auth:2.0.0/" deployments/auth.yaml



kubectl create -f deployments/hello-canary.yaml

kubectl get deployments


kubectl apply -f services/hello-blue.yaml

kubectl create -f deployments/hello-green.yaml

curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version

kubectl apply -f services/hello-green.yaml



echo
echo "${CYAN_TEXT}${BOLD_TEXT}=======================================================${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}              LAB COMPLETED SUCCESSFULLY!              ${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}=======================================================${RESET_FORMAT}"
echo
