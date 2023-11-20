provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.location
  tags     = local.azure_default_tags.default
}

module "network" {
  source                       = "./modules/virtual_network"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = local.location
  vnet_name                    = local.vnet001-name 
  address_space                = local.vnet001-cidr
  tags                         = local.azure_default_tags.default

  subnets = [
    {
      name : local.vnet001-app-subnet
      address_prefixes : local.vnet001-app-subnet-cidr
      enforce_private_link_endpoint_network_policies : true
      enforce_private_link_service_network_policies : true
    },
    {
      name : local.vnet001-db-subnet
      address_prefixes : local.vnet001-db-subnet-cidr
      enforce_private_link_endpoint_network_policies : true
      enforce_private_link_service_network_policies : true
    },
    {
      name : local.vnet001-pvt-subnet
      address_prefixes : local.vnet001-pvt-subnet-cidr
      enforce_private_link_endpoint_network_policies : true
      enforce_private_link_service_network_policies : true
    }
  ]
  depends_on = [ azurerm_resource_group.rg ]
}

module "routetable" {
  source               = "./modules/route_table"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = local.location
  route_table_name     = local.snet-rt-name
  route_name           = local.snet-rt-rule
  firewall_private_ip  = local.firewall_private_ip
  subnets_to_associate = {
    (local.vnet001-app-subnet) = {
      subscription_id      = data.azurerm_client_config.current.subscription_id
      resource_group_name  = azurerm_resource_group.rg.name
      virtual_network_name = module.network.name
    }
  }
  depends_on = [ module.network ]
}

module "aks_cluster" {
  source                                   = "./modules/aks"
  name                                     = local.aks_cluster_name
  location                                 = local.location
  resource_group_name                      = azurerm_resource_group.rg.name
  resource_group_id                        = azurerm_resource_group.rg.id
  kubernetes_version                       = local.kubernetes_version
  dns_prefix                               = lower(local.aks_cluster_name)
  private_cluster_enabled                  = true
  automatic_channel_upgrade                = local.automatic_channel_upgrade
  sku_tier                                 = local.sku_tier
  default_node_pool_name                   = local.default_node_pool_name
  default_node_pool_vm_size                = local.default_node_pool_vm_size
  vnet_subnet_id                           = module.aks_network.subnet_ids[local.vnet001-aks-subnet]
  default_node_pool_availability_zones     = local.default_node_pool_availability_zones
  default_node_pool_node_labels            = local.default_node_pool_node_labels
  default_node_pool_node_taints            = local.default_node_pool_node_taints
  default_node_pool_enable_auto_scaling    = local.default_node_pool_enable_auto_scaling
  default_node_pool_enable_host_encryption = local.default_node_pool_enable_host_encryption
  default_node_pool_enable_node_public_ip  = local.default_node_pool_enable_node_public_ip
  default_node_pool_max_pods               = local.default_node_pool_max_pods
  default_node_pool_max_count              = local.default_node_pool_max_count
  default_node_pool_min_count              = local.default_node_pool_min_count
  default_node_pool_node_count             = local.default_node_pool_node_count
  default_node_pool_os_disk_type           = local.default_node_pool_os_disk_type
  tags                                     = local.azure_default_tags.default
  network_dns_service_ip                   = local.network_dns_service_ip
  network_plugin                           = local.network_plugin
  outbound_type                            = "userDefinedRouting"
  network_service_cidr                     = local.network_service_cidr
  log_analytics_workspace_id               = module.log_analytics_workspace.id
  role_based_access_control_enabled        = local.role_based_access_control_enabled
  tenant_id                                = data.azurerm_client_config.current.tenant_id
  admin_group_object_ids                   = local.admin_group_object_ids
  azure_rbac_enabled                       = local.azure_rbac_enabled
  admin_username                           = local.admin_username
  ssh_public_key                           = local.ssh_public_key
  keda_enabled                             = local.keda_enabled
  vertical_pod_autoscaler_enabled          = local.vertical_pod_autoscaler_enabled
  image_cleaner_enabled                    = local.image_cleaner_enabled
  azure_policy_enabled                     = local.azure_policy_enabled
  http_application_routing_enabled         = local.http_application_routing_enabled

  depends_on                               = [module.routetable]
}


