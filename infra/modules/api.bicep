param api_management_id string
param api_name string
param api_display_name string
param api_path string
param api_service_url string

resource api_management 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: api_management_id
}

resource api 'Microsoft.ApiManagement/service/apis@2021-08-01' = {
  parent: api_management
  name: api_name
  properties: {
    displayName: api_display_name
    path: api_path
    serviceUrl: api_service_url
    protocols: [
      'https'
    ]
  }
}

resource product 'Microsoft.ApiManagement/service/products@2021-08-01' = {
  parent: api_management
  name: 'starter'
  properties: {
    displayName: 'Starter'
    description: 'Starter product for developers'
    terms: 'Terms of use'
    subscriptionRequired: true
    approvalRequired: false
    subscriptionsLimit: 1
    state: 'published'
  }
}

resource apiProduct 'Microsoft.ApiManagement/service/products/apis@2021-08-01' = {
  parent: product
  name: api_name
  properties: {
    apiId: api.id
  }
}
