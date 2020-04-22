#!/bin/zsh
# Tags
date=`date`
# Variables
rgName="az-203-batch"
location="UK South"
srtAccName="domoaz203batch"
btcAccName="domoazbatch"
btcPoolName="domoazpool"

#Resource Group
az group create -n $rgName -l $location --tags date=$date

#Storage Account
az storage account create -n $srtAccName -g $rgName -l $location --kind StorageV2 --sku Standard_LRS --tags date=$date

#Batch Account
az batch account create -n $btcAccName -g $rgName -l $location --storage-account $srtAccName

#Batch Auth
az batch account login -n $btcAccName -g $rgName
#--shared-key-auth to use a key instead of AD or Service Principle. 

#Batch Pool
az batch pool create --id $btcPoolName --node-agent-sku-id "batch.node.ubuntu 16.04" --vm-size Standard_A1_v2 --target-dedicated-nodes 2 --image canonical:ubuntuserver:16.04-LTS
az batch pool show --pool-id $btcPoolName --query "allocationState"

#Batch Job
az batch job create --id myJob --pool-id $btcPoolName

#Batch Task
az batch task create --task-id myTask --job-id myJob --command-line "/bin/bash -c 'printenv | grep AZ_BATCH; sleep 90s'"
# --resource-files can be used to download files to the nodes before running the --command-line.  Public or read SAS. 
az batch task show --job-id myJob --task-id myTask
az batch task file list --job-id myJob --task-id myTask --output table
az batch task file download --job-id myJob --task-id myTask --file-path stdout.txt --destination ./stdout-task-txt

#DELETE
az batch task stop --job-id myJob --task-id myTask
az batch pool delete -n $btcPoolName
az group delete -n $rgName