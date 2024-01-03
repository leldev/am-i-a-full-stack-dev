param name string

param frontDoorEndpointName string

@allowed([
  'Standard_AzureFrontDoor'
  'Premium_AzureFrontDoor'
])
param frontDoorSkuName string = 'Standard_AzureFrontDoor'

param defaultHostName string

param apiHostName string

param customDomainName string

param customDomain string

var defaultOriginGroupName = 'default-origin-group'
var defaultOriginName = 'default-origin'
var defaultRouteName = 'default-route'

var apiOriginGroupName = 'api-origin-group'
var apiOriginName = 'api-origin'
var apiRouteName = 'api-route'

resource frontDoorProfile 'Microsoft.Cdn/profiles@2021-06-01' = {
  name: name
  location: 'global'
  sku: {
    name: frontDoorSkuName
  }
}

resource frontDoorEndpoint 'Microsoft.Cdn/profiles/afdEndpoints@2021-06-01' = {
  name: frontDoorEndpointName
  parent: frontDoorProfile
  location: 'global'
  properties: {
    enabledState: 'Enabled'
  }
}

resource domain 'Microsoft.Cdn/profiles/customdomains@2021-06-01' = {
  parent: frontDoorProfile
  name: customDomainName
  properties: {
    hostName: customDomain
    tlsSettings: {
      certificateType: 'ManagedCertificate'
      minimumTlsVersion: 'TLS12'
    }
  }
}

// default
resource frontDoorOriginGroup 'Microsoft.Cdn/profiles/originGroups@2021-06-01' = {
  name: defaultOriginGroupName
  parent: frontDoorProfile
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
    }
    healthProbeSettings: {
      probePath: '/'
      probeRequestType: 'HEAD'
      probeProtocol: 'Https'
      probeIntervalInSeconds: 100
    }
  }
}

resource frontDoorOrigin 'Microsoft.Cdn/profiles/originGroups/origins@2021-06-01' = {
  name: defaultOriginName
  parent: frontDoorOriginGroup
  properties: {
    hostName: defaultHostName
    httpPort: 80
    httpsPort: 443
    originHostHeader: defaultHostName
    priority: 1
    weight: 1000
  }
}

resource frontDoorRoute 'Microsoft.Cdn/profiles/afdEndpoints/routes@2021-06-01' = {
  name: defaultRouteName
  parent: frontDoorEndpoint
  dependsOn: [
    frontDoorOrigin
  ]
  properties: {
    customDomains: [
      { id: domain.id }
    ]
    originGroup: {
      id: frontDoorOriginGroup.id
    }
    supportedProtocols: [
      'Http'
      'Https'
    ]
    patternsToMatch: [
      '/*'
    ]
    forwardingProtocol: 'MatchRequest'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
  }
}

// api 
resource apiOriginGroup 'Microsoft.Cdn/profiles/originGroups@2021-06-01' = {
  name: apiOriginGroupName
  parent: frontDoorProfile
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
    }
    healthProbeSettings: {
      probePath: '/'
      probeRequestType: 'HEAD'
      probeProtocol: 'Https'
      probeIntervalInSeconds: 100
    }
  }
}

resource apiOrigin 'Microsoft.Cdn/profiles/originGroups/origins@2021-06-01' = {
  name: apiOriginName
  parent: apiOriginGroup
  properties: {
    hostName: apiHostName
    httpPort: 80
    httpsPort: 443
    originHostHeader: apiHostName
    priority: 1
    weight: 1000
  }
}

resource apiRoute 'Microsoft.Cdn/profiles/afdEndpoints/routes@2021-06-01' = {
  name: apiRouteName
  parent: frontDoorEndpoint
  dependsOn: [
    apiOrigin
  ]
  properties: {
    customDomains: [
      { id: domain.id }
    ]
    originGroup: {
      id: apiOriginGroup.id
    }
    supportedProtocols: [
      'Http'
      'Https'
    ]
    patternsToMatch: [
      '/api'
      '/api/*'
      '/swagger'
      '/swagger/*'
    ]
    forwardingProtocol: 'MatchRequest'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
  }
}

output frontDoorProfile object = frontDoorProfile
output frontDoorEndpoint object = frontDoorEndpoint
output domain object = domain
