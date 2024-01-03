param name string

@allowed([
  //name  Tier          Full name
  'D1' //Shared      an D1 Shared
  'F1' //Free        an F1 Free
  'B1' //Basic       an B1 Basic
  'B2' //Basic       an B2 Basic
  'B3' //Basic       an B3 Basic
  'S1' //Standard    an S1 Standard
  'S2' //Standard    an S2 Standard
  'S3' //Standard    an S3 Standard
  'P1' //Premium     an P1 Premium
  'P2' //Premium     an P2 Premium
  'P3' //Premium     an P3 Premium
  'P1V2' //PremiumV2   an P1V2 PremiumV2
  'P2V2' //PremiumV2   an P2V2 PremiumV2
  'P3V2' //PremiumV2   an P3V2 PremiumV2
  'I1' //Isolated    an I2 Isolated
  'I2' //Isolated    an I2 Isolated
  'I3' //Isolated    an I3 Isolated
  'Y1' //Dynamic     a  function consumption plan
  'EP1' //ElasticPremium
  'EP2' //ElasticPremium
  'EP3' //ElasticPremium
])

param appServicePlanSkuTier string

param appName string

param sqlConnectionString string

param appInsightsConnectionString string

param location string = resourceGroup().location

var allSettings = [
  {
    name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
    value: appInsightsConnectionString
  }
  {
    name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
    value: '~2'
  }
  {
    name: 'XDT_MicrosoftApplicationInsights_Mode'
    value: 'recommended'
  }
  {
    name: 'InstrumentationEngine_EXTENSION_VERSION'
    value: '~1'
  }
  {
    name: 'XDT_MicrosoftApplicationInsights_BaseExtensions'
    value: '~1'
  }
]

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: name
  location: location
  sku: {
    name: appServicePlanSkuTier
  }
}

resource webApplication 'Microsoft.Web/sites@2022-03-01' = {
  name: appName
  location: location
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/appServicePlan': 'Resource'
  }
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: allSettings
      http20Enabled: true
      connectionStrings: [
        {
          name: 'Default'
          connectionString: sqlConnectionString
          type: 'SQLAzure'
        }
      ]
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

output appServicePlan object = appServicePlan
output webApplication object = webApplication
output defaultHostName string = webApplication.properties.defaultHostName
