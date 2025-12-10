param webAppName string
param location string
param planId string
param acrLoginServer string
param managedIdentity bool = true

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: planId
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|6.0'
      appSettings: [
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
      ]
    }
  }
  identity: managedIdentity ? {
    type: 'SystemAssigned'
  } : null
}

output webAppName string = webApp.name
output managedIdentityPrincipalId string = managedIdentity ? webApp.identity.principalId : ''
