param nsg_name string 
param location string
param default_tag_name string
param default_tag_value string

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

output id string = nsg.id
