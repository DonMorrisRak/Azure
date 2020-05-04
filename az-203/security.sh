#!/bin/zsh
rgName="az-203-security"
location="UK South"
srtAccName="domoaz203sec"

spName="DoMoAZSP"

### RSG Create
az group create -n $rgName -l $location
### Storage Account Create
az storage account create -n $srtAccName -g $rgName -l $location --sku Standard_LRS

### Create Service Principle. 
az ad sp create-for-rbac --name $spName

### Get App ID:
appId=`az ad sp list --display-name $spName --query "[0].appId" --output tsv`

### Show SP
az ad sp show --id $appId

### Show role assignments for the SP
az role assignment list --assignee $appId
### Define the Roles. 
az role definition list
### Assign a role to a SP
az role assignment create --role "Website Contributor" --assignee $appId 
# Use --scope to define specific scopes to resource IDs.  ### az <resource> show --query id. 

### Reset SP credential
az ad sp credential reset --name $appId

### Create Key Vault.

az webapp identity assign --name myApp --resource-group myResourceGroup - Note the Principle ID. 
az keyvault set-policy --name myKeyVault --object-id <PrincipalId> --secret-permissions get list 
