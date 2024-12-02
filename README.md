# API Management Demo Environment:
This demo creates an environment for API management that shows how to leverage it to support connecting to a backend application.  

# Pre-requisites:
The following are pre-requisites for using this repo:
- Azure CLI

# Installation Instructions for Azure CLI
The following are the steps for installing the Azure CLI.

## Installation Steps:

### Windows:
1. Download the Azure CLI installer from the [official Azure CLI page](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest).
2. Run the installer and follow the on-screen instructions.

### macOS:
1. Open your terminal.
2. Run the following command to install Azure CLI using Homebrew:
    ```sh
    brew update && brew install azure-cli
    ```

### Linux:
1. Open your terminal.
2. Run the following commands to install Azure CLI using the package manager:
    ```sh
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    ```

## Verification:
After installation, you can verify the installation by running:

# Deploying the environment
For this demo, all infrastructure is included via bicep templates to attached to an existing virtual network.  

## Creating a Virtual Network via Azure CLI (if one does not exist):

To create a virtual network using Azure CLI, follow these steps:

1. Open your terminal.
2. Ensure you are logged in to your Azure account:
    ```sh
    az login
    ```
3. Create a resource group if you don't have one:
    ```sh
    az group create --name MyResourceGroup --location eastus
    ```
4. Create the virtual network:
    ```sh
    az network vnet create --name MyVnet --resource-group MyResourceGroup --subnet-name MySubnet
    ```

You have now created a virtual network with a subnet in the specified resource group.

## Deployment Instructions for Bicep Template

This documentation provides the steps to deploy the Bicep template located at `./infra/main.bicep`.

**Bicep CLI**: Ensure you have the Bicep CLI installed. You can follow the installation instructions [here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install).

### Steps to Deploy

1. **Login to Azure**: Open your terminal and login to your Azure account using the following command:
    ```sh
    az cloud set --name AzureUSGovernment
    az login
    ```

2. **Set the Subscription**: If you have multiple subscriptions, set the desired subscription using:
    ```sh
    az account set --subscription <your-subscription-id>
    ```

3. **Set the Parameters**:  Create a file called "main.parameters.json" at the file path of "./infra/main.parameters.json."

The contents of the file should be:
```json
{
  "project_prefix": {
    "value": "myProject"
  },
  "env_prefix": {
    "value": "dev"
  },
  "location": {
    "value": "eastus"
  },
  "existing_network_name": {
    "value": "myNetwork"
  },
  "vnet_rg_name": {
    "value": "myResourceGroup"
  },
  "default_tag_name": {
    "value": "environment"
  },
  "default_tag_value": {
    "value": "development"
  },
  "api_management_admin_email": {
    "value": "admin@example.com"
  },
  "api_management_publisher_name": {
    "value": "MyPublisher"
  },
  "api_name": {
    "value": "myApi"
  },
  "api_display_name": {
    "value": "My API"
  },
  "api_path": {
    "value": "myapi"
  },
  "api_service_url": {
    "value": "https://myapi.example.com"
  }
}
```

4. **Deploy the Bicep Template**: Use the following command to deploy the Bicep template:
    ```sh
    az deployment sub create --template-file ./infra/main.bicep --parameters @./infra/main.parameters.json
    ```