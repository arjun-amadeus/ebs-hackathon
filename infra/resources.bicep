@description('The location used for all deployed resources')
param location string = resourceGroup().location

@description('Tags that will be applied to all resources')
param tags object = {}


param galataExtensionExists bool
param stagingExists bool
param staticExists bool
param extensionExists bool
param incompatExists bool
param consumerExists bool
param providerExists bool
param tokenExists bool
param mimeextensionExists bool
param packageExists bool
param testHyphensExists bool
param testHyphensUnderscoreExists bool
param testNoHyphensExists bool
param executableExists bool
param staticExists bool
param labExtensionExists bool
param jupyterlabManagerExists bool
param jupyterlabPygmentsExists bool

@description('Id of the user or app to assign application roles')
param principalId string

var abbrs = loadJsonContent('./abbreviations.json')
var resourceToken = uniqueString(subscription().id, resourceGroup().id, location)

// Monitor application with Azure Monitor
module monitoring 'br/public:avm/ptn/azd/monitoring:0.1.0' = {
  name: 'monitoring'
  params: {
    logAnalyticsName: '${abbrs.operationalInsightsWorkspaces}${resourceToken}'
    applicationInsightsName: '${abbrs.insightsComponents}${resourceToken}'
    applicationInsightsDashboardName: '${abbrs.portalDashboards}${resourceToken}'
    location: location
    tags: tags
  }
}

// Container registry
module containerRegistry 'br/public:avm/res/container-registry/registry:0.1.1' = {
  name: 'registry'
  params: {
    name: '${abbrs.containerRegistryRegistries}${resourceToken}'
    location: location
    tags: tags
    publicNetworkAccess: 'Enabled'
    roleAssignments:[
      {
        principalId: galataExtensionIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
      }
      {
        principalId: stagingIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
      }
      {
        principalId: staticIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
      }
      {
        principalId: extensionIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
      }
      {
        principalId: incompatIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
      }
      {
        principalId: consumerIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
      }
      {
        principalId: providerIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
      }
      {
        principalId: tokenIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
      }
      {
        principalId: mimeextensionIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
      }
      {
        principalId: packageIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
      }
      {
        principalId: testHyphensIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
      }
      {
        principalId: testHyphensUnderscoreIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
      }
      {
        principalId: testNoHyphensIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
      }
      {
        principalId: executableIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
      }
      {
        principalId: staticIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
      }
      {
        principalId: labExtensionIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
      }
      {
        principalId: jupyterlabManagerIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
      }
      {
        principalId: jupyterlabPygmentsIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
      }
    ]
  }
}

// Container apps environment
module containerAppsEnvironment 'br/public:avm/res/app/managed-environment:0.4.5' = {
  name: 'container-apps-environment'
  params: {
    logAnalyticsWorkspaceResourceId: monitoring.outputs.logAnalyticsWorkspaceResourceId
    name: '${abbrs.appManagedEnvironments}${resourceToken}'
    location: location
    zoneRedundant: false
  }
}

module galataExtensionIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: 'galataExtensionidentity'
  params: {
    name: '${abbrs.managedIdentityUserAssignedIdentities}galataExtension-${resourceToken}'
    location: location
  }
}

module galataExtensionFetchLatestImage './modules/fetch-container-image.bicep' = {
  name: 'galataExtension-fetch-image'
  params: {
    exists: galataExtensionExists
    name: 'galata-extension'
  }
}

module galataExtension 'br/public:avm/res/app/container-app:0.8.0' = {
  name: 'galataExtension'
  params: {
    name: 'galata-extension'
    ingressTargetPort: 80
    corsPolicy: {
      allowedOrigins: [
        'https://jupyterlab-manager.${containerAppsEnvironment.outputs.defaultDomain}'
      ]
      allowedMethods: [
        '*'
      ]
    }
    scaleMinReplicas: 1
    scaleMaxReplicas: 10
    secrets: {
      secureList:  [
      ]
    }
    containers: [
      {
        image: galataExtensionFetchLatestImage.outputs.?containers[?0].?image ?? 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'main'
        resources: {
          cpu: json('0.5')
          memory: '1.0Gi'
        }
        env: [
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: monitoring.outputs.applicationInsightsConnectionString
          }
          {
            name: 'AZURE_CLIENT_ID'
            value: galataExtensionIdentity.outputs.clientId
          }
          {
            name: 'PORT'
            value: '80'
          }
        ]
      }
    ]
    managedIdentities:{
      systemAssigned: false
      userAssignedResourceIds: [galataExtensionIdentity.outputs.resourceId]
    }
    registries:[
      {
        server: containerRegistry.outputs.loginServer
        identity: galataExtensionIdentity.outputs.resourceId
      }
    ]
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    location: location
    tags: union(tags, { 'azd-service-name': 'galata-extension' })
  }
}

module stagingIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: 'stagingidentity'
  params: {
    name: '${abbrs.managedIdentityUserAssignedIdentities}staging-${resourceToken}'
    location: location
  }
}

module stagingFetchLatestImage './modules/fetch-container-image.bicep' = {
  name: 'staging-fetch-image'
  params: {
    exists: stagingExists
    name: 'staging'
  }
}

module staging 'br/public:avm/res/app/container-app:0.8.0' = {
  name: 'staging'
  params: {
    name: 'staging'
    ingressTargetPort: 80
    corsPolicy: {
      allowedOrigins: [
        'https://jupyterlab-manager.${containerAppsEnvironment.outputs.defaultDomain}'
      ]
      allowedMethods: [
        '*'
      ]
    }
    scaleMinReplicas: 1
    scaleMaxReplicas: 10
    secrets: {
      secureList:  [
      ]
    }
    containers: [
      {
        image: stagingFetchLatestImage.outputs.?containers[?0].?image ?? 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'main'
        resources: {
          cpu: json('0.5')
          memory: '1.0Gi'
        }
        env: [
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: monitoring.outputs.applicationInsightsConnectionString
          }
          {
            name: 'AZURE_CLIENT_ID'
            value: stagingIdentity.outputs.clientId
          }
          {
            name: 'PORT'
            value: '80'
          }
        ]
      }
    ]
    managedIdentities:{
      systemAssigned: false
      userAssignedResourceIds: [stagingIdentity.outputs.resourceId]
    }
    registries:[
      {
        server: containerRegistry.outputs.loginServer
        identity: stagingIdentity.outputs.resourceId
      }
    ]
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    location: location
    tags: union(tags, { 'azd-service-name': 'staging' })
  }
}

module staticIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: 'staticidentity'
  params: {
    name: '${abbrs.managedIdentityUserAssignedIdentities}static-${resourceToken}'
    location: location
  }
}

module staticFetchLatestImage './modules/fetch-container-image.bicep' = {
  name: 'static-fetch-image'
  params: {
    exists: staticExists
    name: 'static'
  }
}

module static 'br/public:avm/res/app/container-app:0.8.0' = {
  name: 'static'
  params: {
    name: 'static'
    ingressTargetPort: 80
    corsPolicy: {
      allowedOrigins: [
        'https://jupyterlab-manager.${containerAppsEnvironment.outputs.defaultDomain}'
      ]
      allowedMethods: [
        '*'
      ]
    }
    scaleMinReplicas: 1
    scaleMaxReplicas: 10
    secrets: {
      secureList:  [
      ]
    }
    containers: [
      {
        image: staticFetchLatestImage.outputs.?containers[?0].?image ?? 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'main'
        resources: {
          cpu: json('0.5')
          memory: '1.0Gi'
        }
        env: [
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: monitoring.outputs.applicationInsightsConnectionString
          }
          {
            name: 'AZURE_CLIENT_ID'
            value: staticIdentity.outputs.clientId
          }
          {
            name: 'PORT'
            value: '80'
          }
        ]
      }
    ]
    managedIdentities:{
      systemAssigned: false
      userAssignedResourceIds: [staticIdentity.outputs.resourceId]
    }
    registries:[
      {
        server: containerRegistry.outputs.loginServer
        identity: staticIdentity.outputs.resourceId
      }
    ]
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    location: location
    tags: union(tags, { 'azd-service-name': 'static' })
  }
}

module extensionIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: 'extensionidentity'
  params: {
    name: '${abbrs.managedIdentityUserAssignedIdentities}extension-${resourceToken}'
    location: location
  }
}

module extensionFetchLatestImage './modules/fetch-container-image.bicep' = {
  name: 'extension-fetch-image'
  params: {
    exists: extensionExists
    name: 'extension'
  }
}

module extension 'br/public:avm/res/app/container-app:0.8.0' = {
  name: 'extension'
  params: {
    name: 'extension'
    ingressTargetPort: 80
    corsPolicy: {
      allowedOrigins: [
        'https://jupyterlab-manager.${containerAppsEnvironment.outputs.defaultDomain}'
      ]
      allowedMethods: [
        '*'
      ]
    }
    scaleMinReplicas: 1
    scaleMaxReplicas: 10
    secrets: {
      secureList:  [
      ]
    }
    containers: [
      {
        image: extensionFetchLatestImage.outputs.?containers[?0].?image ?? 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'main'
        resources: {
          cpu: json('0.5')
          memory: '1.0Gi'
        }
        env: [
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: monitoring.outputs.applicationInsightsConnectionString
          }
          {
            name: 'AZURE_CLIENT_ID'
            value: extensionIdentity.outputs.clientId
          }
          {
            name: 'PORT'
            value: '80'
          }
        ]
      }
    ]
    managedIdentities:{
      systemAssigned: false
      userAssignedResourceIds: [extensionIdentity.outputs.resourceId]
    }
    registries:[
      {
        server: containerRegistry.outputs.loginServer
        identity: extensionIdentity.outputs.resourceId
      }
    ]
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    location: location
    tags: union(tags, { 'azd-service-name': 'extension' })
  }
}

module incompatIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: 'incompatidentity'
  params: {
    name: '${abbrs.managedIdentityUserAssignedIdentities}incompat-${resourceToken}'
    location: location
  }
}

module incompatFetchLatestImage './modules/fetch-container-image.bicep' = {
  name: 'incompat-fetch-image'
  params: {
    exists: incompatExists
    name: 'incompat'
  }
}

module incompat 'br/public:avm/res/app/container-app:0.8.0' = {
  name: 'incompat'
  params: {
    name: 'incompat'
    ingressTargetPort: 80
    corsPolicy: {
      allowedOrigins: [
        'https://jupyterlab-manager.${containerAppsEnvironment.outputs.defaultDomain}'
      ]
      allowedMethods: [
        '*'
      ]
    }
    scaleMinReplicas: 1
    scaleMaxReplicas: 10
    secrets: {
      secureList:  [
      ]
    }
    containers: [
      {
        image: incompatFetchLatestImage.outputs.?containers[?0].?image ?? 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'main'
        resources: {
          cpu: json('0.5')
          memory: '1.0Gi'
        }
        env: [
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: monitoring.outputs.applicationInsightsConnectionString
          }
          {
            name: 'AZURE_CLIENT_ID'
            value: incompatIdentity.outputs.clientId
          }
          {
            name: 'PORT'
            value: '80'
          }
        ]
      }
    ]
    managedIdentities:{
      systemAssigned: false
      userAssignedResourceIds: [incompatIdentity.outputs.resourceId]
    }
    registries:[
      {
        server: containerRegistry.outputs.loginServer
        identity: incompatIdentity.outputs.resourceId
      }
    ]
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    location: location
    tags: union(tags, { 'azd-service-name': 'incompat' })
  }
}

module consumerIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: 'consumeridentity'
  params: {
    name: '${abbrs.managedIdentityUserAssignedIdentities}consumer-${resourceToken}'
    location: location
  }
}

module consumerFetchLatestImage './modules/fetch-container-image.bicep' = {
  name: 'consumer-fetch-image'
  params: {
    exists: consumerExists
    name: 'consumer'
  }
}

module consumer 'br/public:avm/res/app/container-app:0.8.0' = {
  name: 'consumer'
  params: {
    name: 'consumer'
    ingressTargetPort: 80
    corsPolicy: {
      allowedOrigins: [
        'https://jupyterlab-manager.${containerAppsEnvironment.outputs.defaultDomain}'
      ]
      allowedMethods: [
        '*'
      ]
    }
    scaleMinReplicas: 1
    scaleMaxReplicas: 10
    secrets: {
      secureList:  [
      ]
    }
    containers: [
      {
        image: consumerFetchLatestImage.outputs.?containers[?0].?image ?? 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'main'
        resources: {
          cpu: json('0.5')
          memory: '1.0Gi'
        }
        env: [
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: monitoring.outputs.applicationInsightsConnectionString
          }
          {
            name: 'AZURE_CLIENT_ID'
            value: consumerIdentity.outputs.clientId
          }
          {
            name: 'PORT'
            value: '80'
          }
        ]
      }
    ]
    managedIdentities:{
      systemAssigned: false
      userAssignedResourceIds: [consumerIdentity.outputs.resourceId]
    }
    registries:[
      {
        server: containerRegistry.outputs.loginServer
        identity: consumerIdentity.outputs.resourceId
      }
    ]
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    location: location
    tags: union(tags, { 'azd-service-name': 'consumer' })
  }
}

module providerIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: 'provideridentity'
  params: {
    name: '${abbrs.managedIdentityUserAssignedIdentities}provider-${resourceToken}'
    location: location
  }
}

module providerFetchLatestImage './modules/fetch-container-image.bicep' = {
  name: 'provider-fetch-image'
  params: {
    exists: providerExists
    name: 'provider'
  }
}

module provider 'br/public:avm/res/app/container-app:0.8.0' = {
  name: 'provider'
  params: {
    name: 'provider'
    ingressTargetPort: 80
    corsPolicy: {
      allowedOrigins: [
        'https://jupyterlab-manager.${containerAppsEnvironment.outputs.defaultDomain}'
      ]
      allowedMethods: [
        '*'
      ]
    }
    scaleMinReplicas: 1
    scaleMaxReplicas: 10
    secrets: {
      secureList:  [
      ]
    }
    containers: [
      {
        image: providerFetchLatestImage.outputs.?containers[?0].?image ?? 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'main'
        resources: {
          cpu: json('0.5')
          memory: '1.0Gi'
        }
        env: [
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: monitoring.outputs.applicationInsightsConnectionString
          }
          {
            name: 'AZURE_CLIENT_ID'
            value: providerIdentity.outputs.clientId
          }
          {
            name: 'PORT'
            value: '80'
          }
        ]
      }
    ]
    managedIdentities:{
      systemAssigned: false
      userAssignedResourceIds: [providerIdentity.outputs.resourceId]
    }
    registries:[
      {
        server: containerRegistry.outputs.loginServer
        identity: providerIdentity.outputs.resourceId
      }
    ]
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    location: location
    tags: union(tags, { 'azd-service-name': 'provider' })
  }
}

module tokenIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: 'tokenidentity'
  params: {
    name: '${abbrs.managedIdentityUserAssignedIdentities}token-${resourceToken}'
    location: location
  }
}

module tokenFetchLatestImage './modules/fetch-container-image.bicep' = {
  name: 'token-fetch-image'
  params: {
    exists: tokenExists
    name: 'token'
  }
}

module token 'br/public:avm/res/app/container-app:0.8.0' = {
  name: 'token'
  params: {
    name: 'token'
    ingressTargetPort: 80
    corsPolicy: {
      allowedOrigins: [
        'https://jupyterlab-manager.${containerAppsEnvironment.outputs.defaultDomain}'
      ]
      allowedMethods: [
        '*'
      ]
    }
    scaleMinReplicas: 1
    scaleMaxReplicas: 10
    secrets: {
      secureList:  [
      ]
    }
    containers: [
      {
        image: tokenFetchLatestImage.outputs.?containers[?0].?image ?? 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'main'
        resources: {
          cpu: json('0.5')
          memory: '1.0Gi'
        }
        env: [
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: monitoring.outputs.applicationInsightsConnectionString
          }
          {
            name: 'AZURE_CLIENT_ID'
            value: tokenIdentity.outputs.clientId
          }
          {
            name: 'PORT'
            value: '80'
          }
        ]
      }
    ]
    managedIdentities:{
      systemAssigned: false
      userAssignedResourceIds: [tokenIdentity.outputs.resourceId]
    }
    registries:[
      {
        server: containerRegistry.outputs.loginServer
        identity: tokenIdentity.outputs.resourceId
      }
    ]
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    location: location
    tags: union(tags, { 'azd-service-name': 'token' })
  }
}

module mimeextensionIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: 'mimeextensionidentity'
  params: {
    name: '${abbrs.managedIdentityUserAssignedIdentities}mimeextension-${resourceToken}'
    location: location
  }
}

module mimeextensionFetchLatestImage './modules/fetch-container-image.bicep' = {
  name: 'mimeextension-fetch-image'
  params: {
    exists: mimeextensionExists
    name: 'mimeextension'
  }
}

module mimeextension 'br/public:avm/res/app/container-app:0.8.0' = {
  name: 'mimeextension'
  params: {
    name: 'mimeextension'
    ingressTargetPort: 80
    corsPolicy: {
      allowedOrigins: [
        'https://jupyterlab-manager.${containerAppsEnvironment.outputs.defaultDomain}'
      ]
      allowedMethods: [
        '*'
      ]
    }
    scaleMinReplicas: 1
    scaleMaxReplicas: 10
    secrets: {
      secureList:  [
      ]
    }
    containers: [
      {
        image: mimeextensionFetchLatestImage.outputs.?containers[?0].?image ?? 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'main'
        resources: {
          cpu: json('0.5')
          memory: '1.0Gi'
        }
        env: [
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: monitoring.outputs.applicationInsightsConnectionString
          }
          {
            name: 'AZURE_CLIENT_ID'
            value: mimeextensionIdentity.outputs.clientId
          }
          {
            name: 'PORT'
            value: '80'
          }
        ]
      }
    ]
    managedIdentities:{
      systemAssigned: false
      userAssignedResourceIds: [mimeextensionIdentity.outputs.resourceId]
    }
    registries:[
      {
        server: containerRegistry.outputs.loginServer
        identity: mimeextensionIdentity.outputs.resourceId
      }
    ]
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    location: location
    tags: union(tags, { 'azd-service-name': 'mimeextension' })
  }
}

module packageIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: 'packageidentity'
  params: {
    name: '${abbrs.managedIdentityUserAssignedIdentities}package-${resourceToken}'
    location: location
  }
}

module packageFetchLatestImage './modules/fetch-container-image.bicep' = {
  name: 'package-fetch-image'
  params: {
    exists: packageExists
    name: 'package'
  }
}

module package 'br/public:avm/res/app/container-app:0.8.0' = {
  name: 'package'
  params: {
    name: 'package'
    ingressTargetPort: 80
    corsPolicy: {
      allowedOrigins: [
        'https://jupyterlab-manager.${containerAppsEnvironment.outputs.defaultDomain}'
      ]
      allowedMethods: [
        '*'
      ]
    }
    scaleMinReplicas: 1
    scaleMaxReplicas: 10
    secrets: {
      secureList:  [
      ]
    }
    containers: [
      {
        image: packageFetchLatestImage.outputs.?containers[?0].?image ?? 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'main'
        resources: {
          cpu: json('0.5')
          memory: '1.0Gi'
        }
        env: [
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: monitoring.outputs.applicationInsightsConnectionString
          }
          {
            name: 'AZURE_CLIENT_ID'
            value: packageIdentity.outputs.clientId
          }
          {
            name: 'PORT'
            value: '80'
          }
        ]
      }
    ]
    managedIdentities:{
      systemAssigned: false
      userAssignedResourceIds: [packageIdentity.outputs.resourceId]
    }
    registries:[
      {
        server: containerRegistry.outputs.loginServer
        identity: packageIdentity.outputs.resourceId
      }
    ]
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    location: location
    tags: union(tags, { 'azd-service-name': 'package' })
  }
}

module testHyphensIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: 'testHyphensidentity'
  params: {
    name: '${abbrs.managedIdentityUserAssignedIdentities}testHyphens-${resourceToken}'
    location: location
  }
}

module testHyphensFetchLatestImage './modules/fetch-container-image.bicep' = {
  name: 'testHyphens-fetch-image'
  params: {
    exists: testHyphensExists
    name: 'test-hyphens'
  }
}

module testHyphens 'br/public:avm/res/app/container-app:0.8.0' = {
  name: 'testHyphens'
  params: {
    name: 'test-hyphens'
    ingressTargetPort: 80
    corsPolicy: {
      allowedOrigins: [
        'https://jupyterlab-manager.${containerAppsEnvironment.outputs.defaultDomain}'
      ]
      allowedMethods: [
        '*'
      ]
    }
    scaleMinReplicas: 1
    scaleMaxReplicas: 10
    secrets: {
      secureList:  [
      ]
    }
    containers: [
      {
        image: testHyphensFetchLatestImage.outputs.?containers[?0].?image ?? 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'main'
        resources: {
          cpu: json('0.5')
          memory: '1.0Gi'
        }
        env: [
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: monitoring.outputs.applicationInsightsConnectionString
          }
          {
            name: 'AZURE_CLIENT_ID'
            value: testHyphensIdentity.outputs.clientId
          }
          {
            name: 'PORT'
            value: '80'
          }
        ]
      }
    ]
    managedIdentities:{
      systemAssigned: false
      userAssignedResourceIds: [testHyphensIdentity.outputs.resourceId]
    }
    registries:[
      {
        server: containerRegistry.outputs.loginServer
        identity: testHyphensIdentity.outputs.resourceId
      }
    ]
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    location: location
    tags: union(tags, { 'azd-service-name': 'test-hyphens' })
  }
}

module testHyphensUnderscoreIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: 'testHyphensUnderscoreidentity'
  params: {
    name: '${abbrs.managedIdentityUserAssignedIdentities}testHyphensUnderscore-${resourceToken}'
    location: location
  }
}

module testHyphensUnderscoreFetchLatestImage './modules/fetch-container-image.bicep' = {
  name: 'testHyphensUnderscore-fetch-image'
  params: {
    exists: testHyphensUnderscoreExists
    name: 'test-hyphens-underscore'
  }
}

module testHyphensUnderscore 'br/public:avm/res/app/container-app:0.8.0' = {
  name: 'testHyphensUnderscore'
  params: {
    name: 'test-hyphens-underscore'
    ingressTargetPort: 80
    corsPolicy: {
      allowedOrigins: [
        'https://jupyterlab-manager.${containerAppsEnvironment.outputs.defaultDomain}'
      ]
      allowedMethods: [
        '*'
      ]
    }
    scaleMinReplicas: 1
    scaleMaxReplicas: 10
    secrets: {
      secureList:  [
      ]
    }
    containers: [
      {
        image: testHyphensUnderscoreFetchLatestImage.outputs.?containers[?0].?image ?? 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'main'
        resources: {
          cpu: json('0.5')
          memory: '1.0Gi'
        }
        env: [
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: monitoring.outputs.applicationInsightsConnectionString
          }
          {
            name: 'AZURE_CLIENT_ID'
            value: testHyphensUnderscoreIdentity.outputs.clientId
          }
          {
            name: 'PORT'
            value: '80'
          }
        ]
      }
    ]
    managedIdentities:{
      systemAssigned: false
      userAssignedResourceIds: [testHyphensUnderscoreIdentity.outputs.resourceId]
    }
    registries:[
      {
        server: containerRegistry.outputs.loginServer
        identity: testHyphensUnderscoreIdentity.outputs.resourceId
      }
    ]
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    location: location
    tags: union(tags, { 'azd-service-name': 'test-hyphens-underscore' })
  }
}

module testNoHyphensIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: 'testNoHyphensidentity'
  params: {
    name: '${abbrs.managedIdentityUserAssignedIdentities}testNoHyphens-${resourceToken}'
    location: location
  }
}

module testNoHyphensFetchLatestImage './modules/fetch-container-image.bicep' = {
  name: 'testNoHyphens-fetch-image'
  params: {
    exists: testNoHyphensExists
    name: 'test-no-hyphens'
  }
}

module testNoHyphens 'br/public:avm/res/app/container-app:0.8.0' = {
  name: 'testNoHyphens'
  params: {
    name: 'test-no-hyphens'
    ingressTargetPort: 80
    corsPolicy: {
      allowedOrigins: [
        'https://jupyterlab-manager.${containerAppsEnvironment.outputs.defaultDomain}'
      ]
      allowedMethods: [
        '*'
      ]
    }
    scaleMinReplicas: 1
    scaleMaxReplicas: 10
    secrets: {
      secureList:  [
      ]
    }
    containers: [
      {
        image: testNoHyphensFetchLatestImage.outputs.?containers[?0].?image ?? 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'main'
        resources: {
          cpu: json('0.5')
          memory: '1.0Gi'
        }
        env: [
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: monitoring.outputs.applicationInsightsConnectionString
          }
          {
            name: 'AZURE_CLIENT_ID'
            value: testNoHyphensIdentity.outputs.clientId
          }
          {
            name: 'PORT'
            value: '80'
          }
        ]
      }
    ]
    managedIdentities:{
      systemAssigned: false
      userAssignedResourceIds: [testNoHyphensIdentity.outputs.resourceId]
    }
    registries:[
      {
        server: containerRegistry.outputs.loginServer
        identity: testNoHyphensIdentity.outputs.resourceId
      }
    ]
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    location: location
    tags: union(tags, { 'azd-service-name': 'test-no-hyphens' })
  }
}

module executableIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: 'executableidentity'
  params: {
    name: '${abbrs.managedIdentityUserAssignedIdentities}executable-${resourceToken}'
    location: location
  }
}

module executableFetchLatestImage './modules/fetch-container-image.bicep' = {
  name: 'executable-fetch-image'
  params: {
    exists: executableExists
    name: 'executable'
  }
}

module executable 'br/public:avm/res/app/container-app:0.8.0' = {
  name: 'executable'
  params: {
    name: 'executable'
    ingressTargetPort: 80
    corsPolicy: {
      allowedOrigins: [
        'https://jupyterlab-manager.${containerAppsEnvironment.outputs.defaultDomain}'
      ]
      allowedMethods: [
        '*'
      ]
    }
    scaleMinReplicas: 1
    scaleMaxReplicas: 10
    secrets: {
      secureList:  [
      ]
    }
    containers: [
      {
        image: executableFetchLatestImage.outputs.?containers[?0].?image ?? 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'main'
        resources: {
          cpu: json('0.5')
          memory: '1.0Gi'
        }
        env: [
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: monitoring.outputs.applicationInsightsConnectionString
          }
          {
            name: 'AZURE_CLIENT_ID'
            value: executableIdentity.outputs.clientId
          }
          {
            name: 'PORT'
            value: '80'
          }
        ]
      }
    ]
    managedIdentities:{
      systemAssigned: false
      userAssignedResourceIds: [executableIdentity.outputs.resourceId]
    }
    registries:[
      {
        server: containerRegistry.outputs.loginServer
        identity: executableIdentity.outputs.resourceId
      }
    ]
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    location: location
    tags: union(tags, { 'azd-service-name': 'executable' })
  }
}

module staticIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: 'staticidentity'
  params: {
    name: '${abbrs.managedIdentityUserAssignedIdentities}static-${resourceToken}'
    location: location
  }
}

module staticFetchLatestImage './modules/fetch-container-image.bicep' = {
  name: 'static-fetch-image'
  params: {
    exists: staticExists
    name: 'static'
  }
}

module static 'br/public:avm/res/app/container-app:0.8.0' = {
  name: 'static'
  params: {
    name: 'static'
    ingressTargetPort: 80
    corsPolicy: {
      allowedOrigins: [
        'https://jupyterlab-manager.${containerAppsEnvironment.outputs.defaultDomain}'
      ]
      allowedMethods: [
        '*'
      ]
    }
    scaleMinReplicas: 1
    scaleMaxReplicas: 10
    secrets: {
      secureList:  [
      ]
    }
    containers: [
      {
        image: staticFetchLatestImage.outputs.?containers[?0].?image ?? 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'main'
        resources: {
          cpu: json('0.5')
          memory: '1.0Gi'
        }
        env: [
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: monitoring.outputs.applicationInsightsConnectionString
          }
          {
            name: 'AZURE_CLIENT_ID'
            value: staticIdentity.outputs.clientId
          }
          {
            name: 'PORT'
            value: '80'
          }
        ]
      }
    ]
    managedIdentities:{
      systemAssigned: false
      userAssignedResourceIds: [staticIdentity.outputs.resourceId]
    }
    registries:[
      {
        server: containerRegistry.outputs.loginServer
        identity: staticIdentity.outputs.resourceId
      }
    ]
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    location: location
    tags: union(tags, { 'azd-service-name': 'static' })
  }
}

module labExtensionIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: 'labExtensionidentity'
  params: {
    name: '${abbrs.managedIdentityUserAssignedIdentities}labExtension-${resourceToken}'
    location: location
  }
}

module labExtensionFetchLatestImage './modules/fetch-container-image.bicep' = {
  name: 'labExtension-fetch-image'
  params: {
    exists: labExtensionExists
    name: 'lab-extension'
  }
}

module labExtension 'br/public:avm/res/app/container-app:0.8.0' = {
  name: 'labExtension'
  params: {
    name: 'lab-extension'
    ingressTargetPort: 80
    corsPolicy: {
      allowedOrigins: [
        'https://jupyterlab-manager.${containerAppsEnvironment.outputs.defaultDomain}'
      ]
      allowedMethods: [
        '*'
      ]
    }
    scaleMinReplicas: 1
    scaleMaxReplicas: 10
    secrets: {
      secureList:  [
      ]
    }
    containers: [
      {
        image: labExtensionFetchLatestImage.outputs.?containers[?0].?image ?? 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'main'
        resources: {
          cpu: json('0.5')
          memory: '1.0Gi'
        }
        env: [
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: monitoring.outputs.applicationInsightsConnectionString
          }
          {
            name: 'AZURE_CLIENT_ID'
            value: labExtensionIdentity.outputs.clientId
          }
          {
            name: 'PORT'
            value: '80'
          }
        ]
      }
    ]
    managedIdentities:{
      systemAssigned: false
      userAssignedResourceIds: [labExtensionIdentity.outputs.resourceId]
    }
    registries:[
      {
        server: containerRegistry.outputs.loginServer
        identity: labExtensionIdentity.outputs.resourceId
      }
    ]
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    location: location
    tags: union(tags, { 'azd-service-name': 'lab-extension' })
  }
}

module jupyterlabManagerIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: 'jupyterlabManageridentity'
  params: {
    name: '${abbrs.managedIdentityUserAssignedIdentities}jupyterlabManager-${resourceToken}'
    location: location
  }
}

module jupyterlabManagerFetchLatestImage './modules/fetch-container-image.bicep' = {
  name: 'jupyterlabManager-fetch-image'
  params: {
    exists: jupyterlabManagerExists
    name: 'jupyterlab-manager'
  }
}

module jupyterlabManager 'br/public:avm/res/app/container-app:0.8.0' = {
  name: 'jupyterlabManager'
  params: {
    name: 'jupyterlab-manager'
    ingressTargetPort: 80
    scaleMinReplicas: 1
    scaleMaxReplicas: 10
    secrets: {
      secureList:  [
      ]
    }
    containers: [
      {
        image: jupyterlabManagerFetchLatestImage.outputs.?containers[?0].?image ?? 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'main'
        resources: {
          cpu: json('0.5')
          memory: '1.0Gi'
        }
        env: [
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: monitoring.outputs.applicationInsightsConnectionString
          }
          {
            name: 'AZURE_CLIENT_ID'
            value: jupyterlabManagerIdentity.outputs.clientId
          }
          {
            name: 'GALATA-EXTENSION_BASE_URL'
            value: 'https://galata-extension.${containerAppsEnvironment.outputs.defaultDomain}'
          }
          {
            name: 'STAGING_BASE_URL'
            value: 'https://staging.${containerAppsEnvironment.outputs.defaultDomain}'
          }
          {
            name: 'STATIC_BASE_URL'
            value: 'https://static.${containerAppsEnvironment.outputs.defaultDomain}'
          }
          {
            name: 'EXTENSION_BASE_URL'
            value: 'https://extension.${containerAppsEnvironment.outputs.defaultDomain}'
          }
          {
            name: 'INCOMPAT_BASE_URL'
            value: 'https://incompat.${containerAppsEnvironment.outputs.defaultDomain}'
          }
          {
            name: 'CONSUMER_BASE_URL'
            value: 'https://consumer.${containerAppsEnvironment.outputs.defaultDomain}'
          }
          {
            name: 'PROVIDER_BASE_URL'
            value: 'https://provider.${containerAppsEnvironment.outputs.defaultDomain}'
          }
          {
            name: 'TOKEN_BASE_URL'
            value: 'https://token.${containerAppsEnvironment.outputs.defaultDomain}'
          }
          {
            name: 'MIMEEXTENSION_BASE_URL'
            value: 'https://mimeextension.${containerAppsEnvironment.outputs.defaultDomain}'
          }
          {
            name: 'PACKAGE_BASE_URL'
            value: 'https://package.${containerAppsEnvironment.outputs.defaultDomain}'
          }
          {
            name: 'TEST-HYPHENS_BASE_URL'
            value: 'https://test-hyphens.${containerAppsEnvironment.outputs.defaultDomain}'
          }
          {
            name: 'TEST-HYPHENS-UNDERSCORE_BASE_URL'
            value: 'https://test-hyphens-underscore.${containerAppsEnvironment.outputs.defaultDomain}'
          }
          {
            name: 'TEST-NO-HYPHENS_BASE_URL'
            value: 'https://test-no-hyphens.${containerAppsEnvironment.outputs.defaultDomain}'
          }
          {
            name: 'EXECUTABLE_BASE_URL'
            value: 'https://executable.${containerAppsEnvironment.outputs.defaultDomain}'
          }
          {
            name: 'STATIC_BASE_URL'
            value: 'https://static.${containerAppsEnvironment.outputs.defaultDomain}'
          }
          {
            name: 'LAB-EXTENSION_BASE_URL'
            value: 'https://lab-extension.${containerAppsEnvironment.outputs.defaultDomain}'
          }
          {
            name: 'JUPYTERLAB-PYGMENTS_BASE_URL'
            value: 'https://jupyterlab-pygments.${containerAppsEnvironment.outputs.defaultDomain}'
          }
          {
            name: 'PORT'
            value: '80'
          }
        ]
      }
    ]
    managedIdentities:{
      systemAssigned: false
      userAssignedResourceIds: [jupyterlabManagerIdentity.outputs.resourceId]
    }
    registries:[
      {
        server: containerRegistry.outputs.loginServer
        identity: jupyterlabManagerIdentity.outputs.resourceId
      }
    ]
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    location: location
    tags: union(tags, { 'azd-service-name': 'jupyterlab-manager' })
  }
}

module jupyterlabPygmentsIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: 'jupyterlabPygmentsidentity'
  params: {
    name: '${abbrs.managedIdentityUserAssignedIdentities}jupyterlabPygments-${resourceToken}'
    location: location
  }
}

module jupyterlabPygmentsFetchLatestImage './modules/fetch-container-image.bicep' = {
  name: 'jupyterlabPygments-fetch-image'
  params: {
    exists: jupyterlabPygmentsExists
    name: 'jupyterlab-pygments'
  }
}

module jupyterlabPygments 'br/public:avm/res/app/container-app:0.8.0' = {
  name: 'jupyterlabPygments'
  params: {
    name: 'jupyterlab-pygments'
    ingressTargetPort: 80
    corsPolicy: {
      allowedOrigins: [
        'https://jupyterlab-manager.${containerAppsEnvironment.outputs.defaultDomain}'
      ]
      allowedMethods: [
        '*'
      ]
    }
    scaleMinReplicas: 1
    scaleMaxReplicas: 10
    secrets: {
      secureList:  [
      ]
    }
    containers: [
      {
        image: jupyterlabPygmentsFetchLatestImage.outputs.?containers[?0].?image ?? 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'main'
        resources: {
          cpu: json('0.5')
          memory: '1.0Gi'
        }
        env: [
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: monitoring.outputs.applicationInsightsConnectionString
          }
          {
            name: 'AZURE_CLIENT_ID'
            value: jupyterlabPygmentsIdentity.outputs.clientId
          }
          {
            name: 'PORT'
            value: '80'
          }
        ]
      }
    ]
    managedIdentities:{
      systemAssigned: false
      userAssignedResourceIds: [jupyterlabPygmentsIdentity.outputs.resourceId]
    }
    registries:[
      {
        server: containerRegistry.outputs.loginServer
        identity: jupyterlabPygmentsIdentity.outputs.resourceId
      }
    ]
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    location: location
    tags: union(tags, { 'azd-service-name': 'jupyterlab-pygments' })
  }
}
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = containerRegistry.outputs.loginServer
output AZURE_RESOURCE_GALATA_EXTENSION_ID string = galataExtension.outputs.resourceId
output AZURE_RESOURCE_STAGING_ID string = staging.outputs.resourceId
output AZURE_RESOURCE_STATIC_ID string = static.outputs.resourceId
output AZURE_RESOURCE_EXTENSION_ID string = extension.outputs.resourceId
output AZURE_RESOURCE_INCOMPAT_ID string = incompat.outputs.resourceId
output AZURE_RESOURCE_CONSUMER_ID string = consumer.outputs.resourceId
output AZURE_RESOURCE_PROVIDER_ID string = provider.outputs.resourceId
output AZURE_RESOURCE_TOKEN_ID string = token.outputs.resourceId
output AZURE_RESOURCE_MIMEEXTENSION_ID string = mimeextension.outputs.resourceId
output AZURE_RESOURCE_PACKAGE_ID string = package.outputs.resourceId
output AZURE_RESOURCE_TEST_HYPHENS_ID string = testHyphens.outputs.resourceId
output AZURE_RESOURCE_TEST_HYPHENS_UNDERSCORE_ID string = testHyphensUnderscore.outputs.resourceId
output AZURE_RESOURCE_TEST_NO_HYPHENS_ID string = testNoHyphens.outputs.resourceId
output AZURE_RESOURCE_EXECUTABLE_ID string = executable.outputs.resourceId
output AZURE_RESOURCE_STATIC_ID string = static.outputs.resourceId
output AZURE_RESOURCE_LAB_EXTENSION_ID string = labExtension.outputs.resourceId
output AZURE_RESOURCE_JUPYTERLAB_MANAGER_ID string = jupyterlabManager.outputs.resourceId
output AZURE_RESOURCE_JUPYTERLAB_PYGMENTS_ID string = jupyterlabPygments.outputs.resourceId
