#!/bin/zsh
rgName="az-203-storage"
location="UK South"
accountName="domocdb"
databaseName="domosql"

### RSG Create
az group create -n $rgName -l $location

### Cosmos DB account
#accepted values: BoundedStaleness, ConsistentPrefix, Eventual, Session, Strong
az cosmosdb create -n $accountName -g $rgName --default-consistency-level Strong --kind GlobalDocumentDB --locations "East US=0"
#--enable-multiple-write-locations to enable data sync globally, --enable-automatic-failover
# List CosmosDB account Keys
az cosmosdb list-keys -n $accountName -g $rgName
# List CosmosDB Connection Strings
az cosmosdb list-connection-strings -n $accountName -g $rgName
# Show CosmosDB primary endpoint
az cosmosdb show -n $accountName -g $rgName --query "documentEndpoint"

### Cosmod DB Database. 
az cosmosdb database create -n $accountName -g $rgName --db-name $databaseName

### Cosmos DB Collection
az cosmosdb collection create  -n $accountName -g $rgName --db-name $databaseName --collection-name "CollectionDOMO"