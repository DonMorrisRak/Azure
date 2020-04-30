#!/bin/zsh
rgName="az-203-function"
location="UK South"
srtAccName="domofunc"
qName="domoq"
content=`cat /Users/donmorris/Documents/family.json`
fName="domofunc"

### RSG Create
az group create -n $rgName -l $location

### Azure function checks a storage Q and writes those messages to a storage table. 
### Create storage account
az storage account create -n $srtAccName -g $rgName -l $location --sku Standard_LRS --kind StorageV2 --access-tier Hot
### Get Connection String
conString=`az storage account show-connection-string -n $srtAccName --query "connectionString"`

### Create Storage Queue
az storage queue create --name $qName --account-name $srtAccName --connection-string $conString
### Add message to Queue
az storage message put --account-name $srtAccName --connection-string $conString --queue-name $qName --content $content

### Create Function App
az functionapp create -n $fName -g $rgName --storage-account=$srtAccName --disable-app-insights --os-type Linux --runtime python --runtime-version 3.7