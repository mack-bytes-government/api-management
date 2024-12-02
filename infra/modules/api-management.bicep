param api_management_name string
param admin_email string 
param publisher_name string
param location string
param subnet_id string
param default_tag_name string
param default_tag_value string

resource apiManagement 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: api_management_name
  location: location
  sku: {
    name: 'Standard'
    capacity: 1
  }
  properties: {
    publisherEmail: admin_email
    publisherName: publisher_name
    virtualNetworkConfiguration: {
      subnetResourceId: subnet_id
    }
    virtualNetworkType: 'Internal'
  }
  tags: {
    '${default_tag_name}': default_tag_value
  }
}

output id string = apiManagement.id 
