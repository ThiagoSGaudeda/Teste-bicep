
param applicationShortName string
param dbmId string
param environment string
param organization string
param location string
param servicePlanResourceId string
//param instrumentationKey string
//param storageResourceId string

//var storageResourceName = 'st${replace(applicationShortName, '-', '')}'
var functionResourceName = 'func-${applicationShortName}'

resource function 'Microsoft.Web/sites@2021-02-01' = {
  name: functionResourceName
  kind: 'functionapp'
  location: location
  tags: {
    dbm_id: dbmId
    ENV: environment
    ORG: organization
  }
  properties: {
    enabled: true
    httpsOnly: true
    serverFarmId: servicePlanResourceId
    siteConfig: {
      alwaysOn: true
      ftpsState: 'FtpsOnly'
      http20Enabled: false
      ipSecurityRestrictions: [
        {
          ipAddress: 'Any'
          action: 'Allow'
          priority: 1
          name: 'Allow all'
          description: 'Allow all access'
        }
      ]
      minTlsVersion: '1.2'
      scmIpSecurityRestrictionsUseMain: false
      use32BitWorkerProcess: true
      webSocketsEnabled: false
     /* appSettings: [
        {
          name: 'AzureWebJobsDashboard'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageResourceName};AccountKey=${listKeys(storageResourceId, '2019-06-01').keys[0].value}'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageResourceName};AccountKey=${listKeys(storageResourceId, '2019-06-01').keys[0].value}'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: instrumentationKey
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
      ]*/
      numberOfWorkers: 1
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    hostNamesDisabled: false
    clientCertMode: 'Required'
    containerSize: 1536
    dailyMemoryTimeQuota: 0
    redundancyMode: 'None'
    customDomainVerificationId : '060A24DE0EACB46F6BC5C0DEFBFDA5FC0B7FCEE78AC7AC251BAEF6313509F06E'
    storageAccountRequired : false
    keyVaultReferenceIdentity : 'SystemAssigned'
  }
}

resource appfunction 'Microsoft.Web/sites/hostNameBindings@2021-02-01' = {
  parent: function
  name: '${functionResourceName}.azurewebsites.net'
  properties: {
    siteName: functionResourceName
    hostNameType: 'Verified'
  }
}
