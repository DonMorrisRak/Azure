#!/bin/zsh

rgName="az-203-search"
location="UK South"
sName="domo-search"

### RSG Create
az group create -n $rgName -l $location

### Create Search Service
az search service create -n $sName -g $rgName --sku free

### Retrieve the Admin key
az search admin-key show --service-name $sName -g $rgName 

### Service Bus Namespace 
az servicebus namespace create -n $nsName -g $rgName

### Get SBUS Connection String
az servicebus namespace authorization-rule keys list -n $nsName -g $rgName

### Create SBUS Queue
az servicebus queue create --namespace-name $nsName -g $rgName -n domoq

### Enable Disk Encryption on a VM on a ADE enabled key vault
az keyvault create --name $vName --resource-group -g $rgName --enabled-for-disk-encryption
az vm encryption enable --disk-encryption-keyvault $vName --volume-type {ALL, DATA, OS}


az sql db create -g $r -s $sName -n $dName -e GeneralPurpose -f Gen5 -min-capacity 0.5 -c 2 --compute-model Serverless --auto-pause-delay 720