param location string = resourceGroup().location

@minLength(3)
@maxLength(11)
param storageNamePrefix string

@description('Container Registry name.')
param acrName string = 'techsckoolacr'

@description('Service Bus namespace name.')
param asbName string = 'techsckoolasb'

@description('Container App name.')
param appName string = 'techsckoolapp'

@description('Storage account SKU.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
])
param storageSkuName string = 'Standard_LRS'

@description('Container Registry SKU.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param acrSkuName string = 'Basic'

@description('Service Bus SKU.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param asbSkuName string = 'Basic'

@description('Log Analytics workspace name（Container Apps環境のログ収集先）.')
param logAnalyticsName string = 'techsckoollaw'

@description('デプロイするコンテナイメージ。初回はACRにイメージが無くても起動できるよう公開のサンプルイメージを既定値にしている。ACRにアプリイメージをpushしたら "<acrName>.azurecr.io/<image>:<tag>" に差し替える。')
param containerImage string = 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

@description('コンテナが待ち受けるポート番号。')
param targetPort int = 80

@description('最小レプリカ数（0を指定するとアイドル時にスケールインしてコストを抑えられる）。')
param minReplicas int = 0

@description('最大レプリカ数。')
param maxReplicas int = 3

@description('コンテナに割り当てるCPUコア数。')
param cpuCore string = '0.25'

@description('コンテナに割り当てるメモリサイズ。')
param memorySize string = '0.5Gi'

var stgAccName = toLower('${storageNamePrefix}${uniqueString(resourceGroup().id)}')
// Service Bus名前空間名はグローバルに一意である必要があるため、一意なサフィックスを付与する
var asbNameUnique = toLower('${asbName}${uniqueString(resourceGroup().id)}')

resource storage_account 'Microsoft.Storage/storageAccounts@2025-08-01' = {
  name: stgAccName
  location: location
  sku: {
    name: storageSkuName
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    publicNetworkAccess: 'Enabled'
    supportsHttpsTrafficOnly: true
  }
}

resource container_registry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  sku: {
    name: acrSkuName
  }
  properties: {
    adminUserEnabled: true
    publicNetworkAccess: 'Enabled'
  }
}

resource asb 'Microsoft.ServiceBus/namespaces@2024-01-01' = {
  name: asbNameUnique
  location: location
  sku: {
    name: asbSkuName
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    zoneRedundant: false
  }
}

// Container Apps環境のログ出力先。App Service Planと違いVMクォータを消費しない。
resource log_analytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

// Container Apps環境（Consumptionプラン＝サーバーレス。VM/App Serviceクォータ不要）
resource container_app_env 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: '${appName}-env'
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: log_analytics.properties.customerId
        sharedKey: log_analytics.listKeys().primarySharedKey
      }
    }
  }
}

resource container_app 'Microsoft.App/containerApps@2024-03-01' = {
  name: appName
  location: location
  properties: {
    environmentId: container_app_env.id
    configuration: {
      ingress: {
        external: true
        targetPort: targetPort
        transport: 'auto'
        allowInsecure: false
      }
      registries: [
        {
          server: '${acrName}.azurecr.io'
          username: container_registry.listCredentials().username
          passwordSecretRef: 'acr-password'
        }
      ]
      secrets: [
        {
          name: 'acr-password'
          value: container_registry.listCredentials().passwords[0].value
        }
      ]
    }
    template: {
      containers: [
        {
          name: appName
          image: containerImage
          resources: {
            cpu: json(cpuCore)
            memory: memorySize
          }
        }
      ]
      scale: {
        minReplicas: minReplicas
        maxReplicas: maxReplicas
      }
    }
  }
}
