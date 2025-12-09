param principalId string
param acrId string
param role string = 'AcrPull'

resource acrPullRole 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(acrId, principalId, role)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d') // AcrPull
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}
