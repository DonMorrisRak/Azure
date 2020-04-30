#!/bin/zsh
rgName="az-203-app"
location="UK South"
aspName="domo-asp"
webName="domo-app"
gitURL="https://github.com/banago/simple-php-website"
dockURL="dockersamples/static-site"

### RSG Create
az group create -n $rgName -l $location

### App Service Plan Create
az appservice plan create -g $rgName -n $aspName --is-linux --sku B1 --number-of-workers 1

### Web App Create
### List available runtimes: az webapp list-runtimes
###Create webapp and deploy local code: az webapp up
#Github
az webapp create -g $rgName --plan $aspName -n $webName --runtime "php|5.6" --deployment-source-url $gitURL
#Container Image
az webapp create -g $rgName --plan $aspName -n $webName --deployment-container-image-name $dockURL 

### Manage Web App:
az webapp /start/stop/restart -g $rgName -n $webName
az webapp ssh -g $rgName -n $webName
az webapp deployment source delete -g $rgName -n $webName
az webapp deployment source config -g $rgName -n $webName --repo-url $gitURL --repository-type github --manual-integration

### Azure Functions

