@minLength(3)
@maxLength(6)
@description('Application name')
param appName string

@allowed([
  'dev'
  'test'
  'stage'
  'prod'
])
@description('Environment to which the resouces are being deployed to')
param environmentName string

@description('Location/region to which the resouces are being deployed to. Example: eastus, centralus')
param location string

@description('Location/region abbreviation. This goes in resource names. Example: eus, cus etc')
param locationAbbreviation string

@description('Tier/sku to use to create Api app service plan')
param apiAppServicePlanSku string

@description('Azure AD group that acts as an admin on the Azure SQL server')
param azureADSqlAdminGroupName string

@description('Azure AD group that acts as an admin on the Azure SQL server')
param azureADSqlAdminGroupObjectId string

@description('Azure SQL Sku name.')
param sqlSkuName string
@description('Azure SQL Sku Tier/Edition')
param sqlSkuTier string = 'Basic'
@description('Azure SQL Capacity')
param sqlSkuCapacity int = 1
@description('Azure SQL sku family')
param sqlSkuFamily string = ''
@description('Azure SQL size')
param sqlMaxSizeBytes int = 2147483648

param customDomainName string
param customDomain string

targetScope = 'subscription'

var suffix = '${appName}-${locationAbbreviation}-${environmentName}'
var resourceGroupName = 'rg-${suffix}'
var webAppName = 'web-${suffix}'
var apiAppName = 'api-${suffix}'
var appServicePlanName = 'asp-${suffix}'
var sqlDatabaseName = 'sqldb-${suffix}'
var sqlServerName = 'sql-${suffix}'
var appInsightsName = 'appi-${suffix}'
var frontDoorName = 'fd-${suffix}'
var frontDoorEndpointName = '${appName}-${environmentName}'

// Create Resource Group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

output resourceGroup object = resourceGroup
output sarasa string = resourceGroup.name
output resourceGroupName string = resourceGroupName

// Create Static Web App
module staticWebApp 'resources/staticWebApp.bicep' = {
  scope: resourceGroup
  name: 'staticWebAppDeployment'
  params: {
    name: webAppName
    location: resourceGroup.location
  }
}

output staticWebApp object = staticWebApp.outputs.staticWebApp
output staticWebAppName string = staticWebApp.outputs.name

// Create Application Insights
module appInsights 'resources/appInsights.bicep' = {
  scope: resourceGroup
  name: 'appInisghtsDeployment'
  params: {
    name: appInsightsName
    location: resourceGroup.location
  }
}

output appInsights object = appInsights.outputs.appInsights

// Create SQL Server and Databases
module sqlDatabase 'resources/sqlDatabase.bicep' = {
  scope: resourceGroup
  name: 'sqlDatabaseDeployment'
  params: {
    name: sqlServerName
    sqlDatabaseName: sqlDatabaseName
    azureADSqlAdminGroupName: azureADSqlAdminGroupName
    azureADSqlAdminGroupSid: azureADSqlAdminGroupObjectId
    sqlSkuName: sqlSkuName
    sqlSkuTier: sqlSkuTier
    sqlSkuCapacity: sqlSkuCapacity
    sqlSkuFamily: sqlSkuFamily
    sqlMaxSizeBytes: sqlMaxSizeBytes
    location: resourceGroup.location
  }
}

output sqlDatabase object = sqlDatabase.outputs.sqlServer
output sqlDatabaseName string = sqlDatabaseName

var sqlConnectionString = 'Server=tcp:${sqlDatabase.outputs.sqlServer.properties.fullyQualifiedDomainName},1433;Database=${sqlDatabaseName};Authentication=Active Directory Default;'

// Create App Service and Web app
module appService 'resources/appService.bicep' = {
  scope: resourceGroup
  name: 'apiAppServiceDeployment'
  params: {
    name: appServicePlanName
    appName: apiAppName
    appServicePlanSkuTier: apiAppServicePlanSku
    sqlConnectionString: sqlConnectionString
    appInsightsConnectionString: appInsights.outputs.appInsights.properties.ConnectionString
    location: resourceGroup.location
  }
  dependsOn: [
    appInsights
    sqlDatabase
  ]
}

output appServicePlan object = appService.outputs.appServicePlan
output webApplication object = appService.outputs.webApplication

module frontDoor 'resources/frontDoor.bicep' = {
  scope: resourceGroup
  name: 'frontDoorDeployment'
  params: {
    name: frontDoorName
    frontDoorEndpointName: frontDoorEndpointName
    defaultHostName: staticWebApp.outputs.defaultHostname
    apiHostName: appService.outputs.defaultHostName
    customDomain: customDomain
    customDomainName: customDomainName
  }
}

output frontDoorEndpoint object = frontDoor.outputs.frontDoorEndpoint
output frontDoorProfile object = frontDoor.outputs.frontDoorProfile
output domain object = frontDoor.outputs.domain
