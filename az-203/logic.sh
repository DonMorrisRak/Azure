#!/bin/zsh
### Logic App to scan an Azure storage account for blobs that need to be archived and sends a message to Queue. 

rgName="az-203-logic"
location="UK South"
srtAccName="domologicsa"
containerName="logicblob"
qName="domoq"

### RSG Create
az group create -n $rgName -l $location

### Storage Account Create
az storage account create -n $srtAccName -g $rgName -l $location --sku Standard_LRS
### Get Connection String
conString=`az storage account show-connection-string -n $srtAccName --query "connectionString"`

### Blob storage create container
az storage container create --account-name $srtAccName -g $rgName -n $containerName --connection-string $conString 

### Upload Blob to Container
az storage blob upload --container-name $containerName --file /Users/donmorris/Documents/family.json --name family.json --connection-string $conString

### Create Storage Queue
az storage queue create --name $qName --account-name $srtAccName --connection-string $conString

### Check messages in a storage queue
az storage message peek --queue-name $qName --account-name $srtAccName --connection-string $conString --num-messages 10
