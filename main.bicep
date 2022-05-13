@description('The SKU of the App Service Plan')
@allowed([
  'B1'
  'B2'
  'S1'
])
param appServicePlanSkuName string

@description('The name of the environment')
@allowed([
  'dev'
  'prod'
])
param environment string

@description('The Application ID in DBM')
param dbmId string

@description('The ExxonMobil Organization')
param organization string

@description('The location of the resources')
param location string = resourceGroup().location

@description('The name for the storage account')
param storageSkuName string

var applicationShortName = 'reit-messaging-service-${environment}'

param appServicePlanFamily string
param appServicePlanSize string
param appServicePlanTier string

module insights 'insights.bicep' = {
  name: 'insights'
  params: {
    applicationShortName: applicationShortName
    location: location
    dbmId: dbmId
    environment: environment
    organization: organization
  }
}

module storage 'storage.bicep' = {
  name: 'storage'
  params: {
    applicationShortName: applicationShortName
    location: location
    environment: environment
    dbmId: dbmId
    organization: organization
    storageSkuName: storageSkuName
  }
}

module app 'app.bicep' = {
  name: 'app'
  params: {
    applicationShortName: applicationShortName
    environment: environment
    dbmId: dbmId
    organization: organization
    location: location
    appServicePlanSkuName: appServicePlanSkuName
    appServicePlanFamily: appServicePlanFamily
    appServicePlanSize: appServicePlanSize
    appServicePlanTier: appServicePlanTier
  }
}

module function 'function.bicep' = {
  name: 'function'
  params: {
    applicationShortName: applicationShortName
    environment: environment
    dbmId: dbmId
    organization: organization
    location: location
    servicePlanResourceId: app.outputs.servicePlanResourceId
  }
}


