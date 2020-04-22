#!/bin/zsh
# Tags
date=`date`
# Variables
rgName="az-203-aks"
location="UK South"
aksName="domoazaks"

clientID=""
clientSecret=""
subID=""
tenantID=""

#Resource Group
az group create -n $rgName -l $location --tags date=$date

#AKS Cluster
az aks create -n $aksName -g $rgName -l $location --load-balancer-sku basic  --vm-set-type AvailabilitySet --generate-ssh-keys --node-count 1 --node-vm-size Standard_A2_v2 --service-principal $clientID --client-secret $clientSecret

# azureuser is default SSH user unless -u --admin-username is set. 

#AKS Credentials
az aks get-credentials -n $aksName -g $rgName

#Get cluster nodes
kubectl get nodes
#Apply Application
kubectl apply -f azure-vote.yaml
#Check deployment status
kubectl get service azure-vote-front --watch

###https://github.com/Azure-Samples/azure-voting-app-redis