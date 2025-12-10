# GitHub Actions Workflow: Build and Deploy

This workflow builds the ZavaStorefront .NET app as a container and deploys it to Azure App Service.

## Prerequisites

- Azure Container Registry (ACR) and App Service provisioned via the `infra/` Bicep templates
- App Service configured with managed identity and AcrPull role on ACR

## Configure GitHub Secrets

Create the following **secret** in your repository (`Settings > Secrets and variables > Actions > Secrets`):

| Secret Name | Description |
|-------------|-------------|
| `AZURE_CREDENTIALS` | Azure service principal credentials in JSON format (see below) |

### Create Azure Service Principal

Run this command to create a service principal with Contributor access:

```bash
az ad sp create-for-rbac --name "github-actions-sp" --role Contributor \
  --scopes /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP> \
  --sdk-auth
```

Copy the JSON output and save it as the `AZURE_CREDENTIALS` secret.

## Configure GitHub Variables

Create the following **variables** in your repository (`Settings > Secrets and variables > Actions > Variables`):

| Variable Name | Example Value | Description |
|---------------|---------------|-------------|
| `ACR_NAME` | `acrzavastorefrontdev` | Name of your Azure Container Registry |
| `WEBAPP_NAME` | `zavastorefront-dev-ka52j4garejfo` | Name of your Azure App Service |
| `RESOURCE_GROUP` | `rg-dev` | Name of your Azure resource group |

## Trigger the Workflow

The workflow runs automatically on push to `main` or `dev` branches, or manually via the **Actions** tab using "Run workflow".
