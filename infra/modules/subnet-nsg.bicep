param nsg_name string 
param location string
param default_tag_name string
param default_tag_value string
param enable_service_tag_storage bool = false
param enable_service_tag_key_vault bool = false

param block_internet_rules array = [
  {
    name: 'BlockAllInbound'
    properties: {
      priority: 100
      access: 'Deny'
      direction: 'Inbound'
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRange: '*'
      sourceAddressPrefix: 'Internet'
      destinationAddressPrefix: '*'
    }
  }
  {
    name: 'BlockAllOutbound'
    properties: {
      priority: 101
      access: 'Deny'
      direction: 'Outbound'
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRange: '*'
      sourceAddressPrefix: '*'
      destinationAddressPrefix: 'Internet'
    }
  }
]

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: nsg_name
  location: location
  tags: {
    '${default_tag_name}': default_tag_value
  }
  properties: {
    securityRules: block_internet_rules
  }
}

resource nsgRuleKeyVault 'Microsoft.Network/networkSecurityGroups/securityRules@2024-03-01' = if (enable_service_tag_key_vault) {
  name: 'AllowKeyVaultOutbound'
  parent: nsg
  properties: {
    priority: 102
    direction: 'Outbound'
    access: 'Allow'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '443'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: 'AzureKeyVault'
  }
}

resource nsgRuleStorage 'Microsoft.Network/networkSecurityGroups/securityRules@2024-03-01' = if (enable_service_tag_storage) {
  name: 'AllowStorageOutbound'
  parent: nsg
  properties: {
    priority: 103
    direction: 'Outbound'
    access: 'Allow'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '443'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: 'Storage'
  }
}

output id string = nsg.id
