param applicationShortName string
param environment string
param dbmId string
param organization string
param location string
param storageSkuName string


var storageResourceName = '${replace(applicationShortName, '-', '')}storage'

resource storage 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageResourceName
  tags: {
    dbm_id: dbmId
    ENV: environment
    ORG: organization
  }
  location: location
  kind: 'StorageV2'
  sku: {
    name: storageSkuName
  }
  properties: {
    accessTier: 'Hot'
    encryption: {
      services: {
        file: {
          enabled: true
          keyType: 'Account'
        }
        blob: {
          enabled: true
          keyType: 'Account'
        }
      }
      keySource: 'Microsoft.Storage'
    }
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
  }

  resource blobServices 'blobServices@2021-09-01' = {
    name: 'default'
    properties: {
      cors: {
        corsRules: []
      }
      deleteRetentionPolicy: {
        enabled: true
        days: 45
      }
    }
  }
}

output storageResourceId string = storage.id
