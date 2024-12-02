targetScope = 'subscription'
// Basic Parameters
@description('The project abbreviation')
param project_prefix string 

@description('The environment prefix (dev, test, prod)')
@minLength(1)
@maxLength(100)
param env_prefix string

@description('The location of the resource group')
param location string

// Network Implementation:
@description('The id of an existing network to be passed')
param existing_network_name string

@description('The name of the existing resource group')
param vnet_rg_name string

// Subnet Configuration
param project_cidr string = '10.0.1.0/24'
param registry_cidr string = '10.0.2.0/24'
param key_vault_cidr string = '10.0.3.0/24'
param storage_cidr string = '10.0.4.0/24'

// Tag Configuration:
param default_tag_name string
param default_tag_value string

resource existing_rg 'Microsoft.Resources/resourceGroups@2024-07-01' existing = {
  name: vnet_rg_name
}

resource environment_rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${project_prefix}-${env_prefix}-rg'
  location: location
  tags: {
    '${default_tag_name}': default_tag_value
  }
}

//Deploy into a existing network
module existing_network './modules/network.bicep' = {
  name: 'existing-network'
  scope: existing_rg
  params: {
    location: location
    project_prefix: project_prefix
    env_prefix: env_prefix
    existing_network_name: existing_network_name
    project_cidr: project_cidr
    registry_cidr: registry_cidr
    key_vault_cidr: key_vault_cidr
    storage_cidr: storage_cidr
    default_tag_name: default_tag_name
    default_tag_value: default_tag_value
  }
}

module registry './modules/registry.bicep' = {
  name: 'registry'
  scope: environment_rg
  params: {
    acr_name: '${project_prefix}${env_prefix}acr'
    location: location
    subnetId: existing_network.outputs.registry_subnet_id
    vnet_id: existing_network.outputs.id   
    default_tag_name: default_tag_name
    default_tag_value: default_tag_value
  }
}

module storage './modules/storage.bicep' = {
  name: 'storage'
  scope: environment_rg
  params: {
    storage_account_name: '${project_prefix}${env_prefix}stg'
    location: location
    subnet_id: existing_network.outputs.storage_subnet_id
    vnet_id: existing_network.outputs.id
    default_tag_name: default_tag_name
    default_tag_value: default_tag_value
  }
}

module key_vault './modules/key-vault.bicep' = {
  name: 'key-vault'
  scope: environment_rg
  params: {
    key_vault_name: '${project_prefix}-${env_prefix}-kv'
    location: location
    subnet_id: existing_network.outputs.key_vault_subnet_id
    vnet_id: existing_network.outputs.id
    default_tag_name: default_tag_name
    default_tag_value: default_tag_value
  }
}
