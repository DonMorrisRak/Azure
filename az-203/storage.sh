#!/bin/zsh
rgName="az-203-storage"
location="UK South"
srtAccName="domoaz203sa"
tblName="domoaztbl"
policyName="raud"
containerName="domocontainer"
### RSG Create
az group create -n $rgName -l $location
### Storage Account Create
az storage account create -n $srtAccName -g $rgName -l $location --sku Standard_LRS
### Get Connection String
conString=`az storage account show-connection-string -n $srtAccName --query "connectionString"`
### Get Account Key
accKey=`az storage account keys list -n $srtAccName --query "[0].value"`

### Generate SAS Key on a blob
az storage blob generate-sas --account-name $srtAccName -g $rgName --container-name $containerName --name family.json --permissions r
## use --start and --expiry Y-m-d'T'H:M'Z'
### Create a URL to access a blob with SAS token
az storage blob url --sas

### Tables
az storage table create -n $tblName --connection-string $conString
az storage table create -n tblName --account-key $accKey --account-name $srtAccName

### Create Table Policy - Read, Add, Update, Delete. 
az storage table policy create -n $policyName --table-name $tblName --connection-string $conString --permissions raud --expiry 2020-04-24
### Create a table entiry 
az storage entity insert --table-name $tblName --entity PartitionKey=001 RowKey=001 Content=DOMO --connection-string $conString
### Show storage table entity
az storage entity show --partition-key 001 --row-key 001 --table-name $tblName --connection-string $conString
### Filter query using ODATA
az storage entity query --table-name $tblName --filter "PartitionKey eq '001'" --connection-string $conString
az storage entity query --table-name $tblName --filter "PartitionKey eq '001'and RowKey eq '003'" --connection-string $conString

### Blob storage create container
az storage container create --account-name $srtAccName -g $rgName -n $containerName --connection-string $conString 

### Upload Blob to Container
az storage blob upload --container-name $containerName --file /Users/donmorris/Documents/family.json --name family.json --connection-string $conString
az storage blob show --container-name $containerName --name family.json --connection-string $conString --query "etag"

### Copy between Blobs
az storage blob copy start --destination-blob fam.json --destination-container cont2 --source-container domocontainer --source-blob family.json --connection-string $conString

### Update Blob or Container metadata using space-seperated k=v pairs. Overwites existing. 
az storage container metadata show --account-name $srtAccName --name $containerName --connection-string $conString
az storage container metadata update --account-name $srtAccName --name $containerName --connection-string $conString --metadata name=don type=storage
az storage blob service-properties show --account-name $srtAccName --connection-string $conString

### Acquire finite lease for writes. 
az storage blob lease acquire --container-name $containerName --blob-name family.json --connection-string $conString --lease-duration 15


az storage account management-policy create --policy (File in json)

az storage account update --account-name $srtAccName -g $rgName -connection-string $conString --sku Standard_GZRS