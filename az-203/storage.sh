#!/bin/zsh
rgName="az-203-storage"
location="UK South"
srtAccName="domoaz203sa"
tblName="domoaztbl"
policyName="raud"
### RSG Create
az group create -n $rgName -l $location
### Storage Account Create
az storage account create -n $srtAccName -g $rgName -l $location --sku Standard_LRS
### Get Connection String
conString=`az storage account show-connection-string -n $srtAccName --query "connectionString"`

### Tables
az storage table create -n $tblName --connection-string $conString
### Create Table Policy - Read, Add, Update, Delete. 
az storage table policy create -n $policyName --table-name $tblName --connection-string $conString --permissions raud --expiry 2020-04-24
### Create a table entiry 
az storage entity insert --table-name $tblName --entity PartitionKey=001 RowKey=001 Content=DOMO --connection-string $conString
### Show storage table entity
az storage entity show --partition-key 001 --row-key 001 --table-name $tblName --connection-string $conString
### Filter query using ODATA
az storage entity query --table-name $tblName --filter "PartitionKey eq '001'" --connection-string $conString
az storage entity query --table-name $tblName --filter "PartitionKey eq '001'and RowKey eq '003'" --connection-string $conString

### Blob storage
