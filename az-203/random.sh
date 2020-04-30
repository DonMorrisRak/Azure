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

### API Management. 