param app_service_name string
param location string
param app_service_plan_name string
param subnet_id string
param vnet_id string 

param default_tag_name string
param default_tag_value string

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: app_service_plan_name
  location: location
  sku: {
    name: 'P1v2'
    tier: 'PremiumV2'
    size: 'P1v2'
    capacity: 1
  }
  kind: 'linux'
  tags: {
    '${default_tag_name}': default_tag_value
  }
}

resource webApp 'Microsoft.Web/sites@2024-04-01' = {
  name: app_service_name
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      vnetRouteAllEnabled: true
      scmIpSecurityRestrictionsUseMain: false
      ipSecurityRestrictions: [
        {
          ipAddress: '0.0.0.0/0'
          action: 'Deny'
          priority: 100
          name: 'Deny all'
        }
      ]
    }
  }
  tags: {
    '${default_tag_name}': default_tag_value
  }
}

resource vnetIntegration 'Microsoft.Web/sites/virtualNetworkConnections@2024-04-01' = {
  name: 'default'
  parent: webApp
  properties: {
    vnetResourceId: vnet_id
  }
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2024-03-01' = {
  name: '${app_service_name}-privateEndpoint'
  location: location
  properties: {
    subnet: {
      id: subnet_id
    }
    privateLinkServiceConnections: [
      {
        name: '${app_service_name}-privateLink'
        properties: {
          privateLinkServiceId: webApp.id
          groupIds: [
            'sites'
          ]
        }
      }
    ]
  }
  tags: {
    '${default_tag_name}': default_tag_value
  }
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: 'privatelink.azurewebsites.net'
  location: 'global'
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-03-01' = {
  name: 'default'
  parent: privateEndpoint
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'default'
        properties: {
          privateDnsZoneId: privateDnsZone.id
        }
      }
    ]
  }
}
