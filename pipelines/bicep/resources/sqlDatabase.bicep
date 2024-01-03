param name string

param sqlDatabaseName string

param sqlSkuName string
param sqlSkuTier string = 'Basic'
param sqlSkuCapacity int = 1
param sqlSkuFamily string = ''
param sqlMaxSizeBytes int = 2147483648

param azureADSqlAdminGroupName string
param azureADSqlAdminGroupSid string

param location string

resource sqlServer 'Microsoft.Sql/servers@2021-11-01' = {
  name: name
  location: location
  properties: {
    administrators: {
      azureADOnlyAuthentication: true
      principalType: 'Group'
      administratorType: 'ActiveDirectory'
      login: azureADSqlAdminGroupName
      sid: azureADSqlAdminGroupSid
      tenantId: tenant().tenantId
    }
  }

  resource sqlServerDatabase 'databases@2021-11-01' = {
    name: sqlDatabaseName
    location: location
    sku: {
      name: sqlSkuName
      tier: sqlSkuTier
      capacity: sqlSkuCapacity
      family: sqlSkuFamily
    }
    properties: {
      maxSizeBytes: sqlMaxSizeBytes
    }
  }

  resource firewallRule 'firewallRules@2021-11-01' = {
    name: 'AllowAllWindowsAzureIps'
    properties: {
      endIpAddress: '0.0.0.0'
      startIpAddress: '0.0.0.0'
    }
  }
}

output sqlServer object = sqlServer
