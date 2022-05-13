
param applicationShortName string
param location string
param dbmId string
param environment string
param organization string

resource appInsights 'Microsoft.Insights/components@2018-05-01-preview' = {
  name: '${applicationShortName}-insights'
  kind: 'web'
  location: location
  tags: {
    dbm_id: dbmId
    ENV: environment
    ORG: organization
  }
  properties: {
    Application_Type: 'web'
    RetentionInDays: 90
    IngestionMode: 'ApplicationInsights'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

output instrumentationKey string = appInsights.properties.InstrumentationKey
