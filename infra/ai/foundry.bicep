param foundryName string
param location string
param sku string = 'Standard'

resource foundry 'Microsoft.Foundry/workspaces@2023-01-01-preview' = {
  name: foundryName
  location: location
  sku: {
    name: sku
  }
  properties: {
    // Add model configuration here if needed
  }
}

output endpoint string = foundry.properties.endpoint
