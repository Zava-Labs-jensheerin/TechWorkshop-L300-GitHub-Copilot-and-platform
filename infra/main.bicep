// Main Bicep template for ZavaStorefront dev environment in westus3
param environment string = 'dev'
param location string = 'westus3'
param acrSku string = 'Basic'
param appServicePlanSku string = 'B1'
param appName string = 'zavastorefront'
var uniqueSuffix = uniqueString(resourceGroup().id)
param foundrySku string = 'Standard'

module acr 'shared/acr.bicep' = {
  name: 'acrModule'
  params: {
    acrName: 'acr${appName}${environment}'
    location: location
    sku: acrSku
  }
}

module appServicePlan 'appservice/plan.bicep' = {
  name: 'appServicePlanModule'
  params: {
    planName: 'asp-${appName}-${environment}'
    location: location
    sku: appServicePlanSku
  }
}

module webApp 'appservice/webapp.bicep' = {
  name: 'webAppModule'
  params: {
    webAppName: '${appName}-${environment}-${uniqueSuffix}'
    location: location
    planId: appServicePlan.outputs.planId
    acrLoginServer: acr.outputs.loginServer
    managedIdentity: true
  }
}

module appInsights 'monitor/appinsights.bicep' = {
  name: 'appInsightsModule'
  params: {
    appInsightsName: 'ai-${appName}-${environment}'
    location: location
  }
}

// module foundry 'ai/foundry.bicep' = {
//   name: 'foundryModule'
//   params: {
//     foundryName: 'foundry-${appName}-${environment}'
//     location: location
//     sku: foundrySku
//   }
// }

module roleAssignment 'auth/roleAssignment.bicep' = {
  name: 'roleAssignmentModule'
  params: {
    principalId: webApp.outputs.managedIdentityPrincipalId
    acrId: acr.outputs.acrId
    role: 'AcrPull'
  }
}

output acrName string = acr.outputs.acrName
output webAppName string = webApp.outputs.webAppName
output appInsightsConnectionString string = appInsights.outputs.connectionString
// output foundryEndpoint string = foundry.outputs.endpoint
