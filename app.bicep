param location string
param applicationShortName string
param appServicePlanSkuName string
param appServicePlanTier string
param appServicePlanSize string
param appServicePlanFamily string
param dbmId string
param environment string
param organization string

var servicePlanResourceName = '${applicationShortName}-appserviceplan'

resource servicePlanResource 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: servicePlanResourceName
  kind: 'app'
  location: location
  tags: {
    dbm_id: dbmId
    ENV: environment
    ORG: organization
  }
  sku: {
    name: appServicePlanSkuName
    tier: appServicePlanTier
    size: appServicePlanSize
    family: appServicePlanFamily
    capacity: 1
  }
  properties: {
    perSiteScaling: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    elasticScaleEnabled: false
    zoneRedundant: false
  }
}

output servicePlanResourceId string = servicePlanResource.id
