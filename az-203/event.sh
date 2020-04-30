#!/bin/zsh
### Use Event grid to alert a web app when a new blob is uploaded. 
rgName="az-203-event"
location="UK South"
sName="domo-event-hub"
srtAccName="domoaz203ev"
containerName="domocontainer"

tURL="https://raw.githubusercontent.com/Azure-Samples/azure-event-grid-viewer/master/azuredeploy.json"
sitename="domoazehub"

### RSG Create
az group create -n $rgName -l $location

### Storage Account Create
az storage account create -n $srtAccName -g $rgName -l $location --sku Standard_LRS
### Get Connection String
conString=`az storage account show-connection-string -n $srtAccName --query "connectionString"`
### Get Account Key
accKey=`az storage account keys list -n $srtAccName --query "[0].value"`

### Blob storage create container
az storage container create --account-name $srtAccName $srtAccName -n $containerName --connection-string $conString 

### Create Web App to act as Event Endpoint
az group deployment create -g $rgName --template-uri $tURL --parameters siteName=$sitename hostingPlanName=viewerhost

### Register Event Grid provider on the subscription 
az provider register --namespace Microsoft.EventGrid
az provider show --namespace Microsoft.EventGrid --query "registrationState"

### Subscribe to the storage account
endpoint=https://$sitename.azurewebsites.net/api/updates
storageid=$(az storage account show --n $srtAccName -g $rgName --query id --output tsv)
az eventgrid event-subscription create --name domo-blob-ev --endpoint $endpoint --source-resource-id $storageid

### Trigger an Event from Blob Storage ### Upload Blob to Container
az storage blob upload --container-name $containerName --file /Users/donmorris/Documents/family.json --name family.json --connection-string $conString
az storage blob show --container-name $containerName --name family.json --connection-string $conString --query "etag"



 --included-event-types "Microsoft.Storage.BlobCreated"
 --subject-begins-with "/blobServices/default/containers/testcontainer/"