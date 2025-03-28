targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment that can be used as part of naming resource convention')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

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

// Tags that should be applied to all resources.
// 
// Note that 'azd-service-name' tags should be applied separately to service host resources.
// Example usage:
//   tags: union(tags, { 'azd-service-name': <service name in azure.yaml> })
var tags = {
  'azd-env-name': environmentName
}

// Organize resources in a resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${environmentName}'
  location: location
  tags: tags
}

module resources 'resources.bicep' = {
  scope: rg
  name: 'resources'
  params: {
    location: location
    tags: tags
    principalId: principalId
    galataExtensionExists: galataExtensionExists
    stagingExists: stagingExists
    staticExists: staticExists
    extensionExists: extensionExists
    incompatExists: incompatExists
    consumerExists: consumerExists
    providerExists: providerExists
    tokenExists: tokenExists
    mimeextensionExists: mimeextensionExists
    packageExists: packageExists
    testHyphensExists: testHyphensExists
    testHyphensUnderscoreExists: testHyphensUnderscoreExists
    testNoHyphensExists: testNoHyphensExists
    executableExists: executableExists
    staticExists: staticExists
    labExtensionExists: labExtensionExists
    jupyterlabManagerExists: jupyterlabManagerExists
    jupyterlabPygmentsExists: jupyterlabPygmentsExists
  }
}

output AZURE_CONTAINER_REGISTRY_ENDPOINT string = resources.outputs.AZURE_CONTAINER_REGISTRY_ENDPOINT
output AZURE_RESOURCE_GALATA_EXTENSION_ID string = resources.outputs.AZURE_RESOURCE_GALATA_EXTENSION_ID
output AZURE_RESOURCE_STAGING_ID string = resources.outputs.AZURE_RESOURCE_STAGING_ID
output AZURE_RESOURCE_STATIC_ID string = resources.outputs.AZURE_RESOURCE_STATIC_ID
output AZURE_RESOURCE_EXTENSION_ID string = resources.outputs.AZURE_RESOURCE_EXTENSION_ID
output AZURE_RESOURCE_INCOMPAT_ID string = resources.outputs.AZURE_RESOURCE_INCOMPAT_ID
output AZURE_RESOURCE_CONSUMER_ID string = resources.outputs.AZURE_RESOURCE_CONSUMER_ID
output AZURE_RESOURCE_PROVIDER_ID string = resources.outputs.AZURE_RESOURCE_PROVIDER_ID
output AZURE_RESOURCE_TOKEN_ID string = resources.outputs.AZURE_RESOURCE_TOKEN_ID
output AZURE_RESOURCE_MIMEEXTENSION_ID string = resources.outputs.AZURE_RESOURCE_MIMEEXTENSION_ID
output AZURE_RESOURCE_PACKAGE_ID string = resources.outputs.AZURE_RESOURCE_PACKAGE_ID
output AZURE_RESOURCE_TEST_HYPHENS_ID string = resources.outputs.AZURE_RESOURCE_TEST_HYPHENS_ID
output AZURE_RESOURCE_TEST_HYPHENS_UNDERSCORE_ID string = resources.outputs.AZURE_RESOURCE_TEST_HYPHENS_UNDERSCORE_ID
output AZURE_RESOURCE_TEST_NO_HYPHENS_ID string = resources.outputs.AZURE_RESOURCE_TEST_NO_HYPHENS_ID
output AZURE_RESOURCE_EXECUTABLE_ID string = resources.outputs.AZURE_RESOURCE_EXECUTABLE_ID
output AZURE_RESOURCE_STATIC_ID string = resources.outputs.AZURE_RESOURCE_STATIC_ID
output AZURE_RESOURCE_LAB_EXTENSION_ID string = resources.outputs.AZURE_RESOURCE_LAB_EXTENSION_ID
output AZURE_RESOURCE_JUPYTERLAB_MANAGER_ID string = resources.outputs.AZURE_RESOURCE_JUPYTERLAB_MANAGER_ID
output AZURE_RESOURCE_JUPYTERLAB_PYGMENTS_ID string = resources.outputs.AZURE_RESOURCE_JUPYTERLAB_PYGMENTS_ID
