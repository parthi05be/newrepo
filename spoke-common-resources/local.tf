locals {
  location = "southeastasia"
  resource_group_name = "rg-sea-bot-dev-network-001"
 

  ## virtual network information
  vnet001-name = "vnet-sea-bot-dev-003"
  vnet001-cidr = ["172.17.0.0/16"]
  vnet001-app-subnet = "snet-sea-bot-dev-app-001"
  vnet001-app-subnet-cidr = ["172.17.0.0/21"]
  vnet001-db-subnet = "snet-sea-bot-dev-db-001"
  vnet001-db-subnet-cidr = ["172.17.10.0/24"]
  vnet001-pvt-subnet = "snet-sea-bot-dev-pvt-001"
  vnet001-pvt-subnet-cidr = ["172.17.20.0/24"]
  vnet001-aks-subnet = "snet-sea-bot-dev-aks-001"
  vnet001-aks-subnet-cidr = ["172.17.10.0/21"]

  ## Route table information
  snet-rt-name = "rt-sea-bot-dev-001"
  snet-rt-rule = "rt-rule-op-fw-001"

  ## Security group information 
  snt-nsg-name = "nsg-sea-bot-dev-001"
  nsg_rules ={
    rule1 = {
      name = "nsg-rule-001"
      priority = 100
      direction = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range = "*"
      destination_port_range = "*"
      source_address_prefix = "*"
      destination_address_prefix = "*"
    }
  }

  log_analytics_workspace_name = "la-sea-bot-dev-001"
  firewall_private_ip = "10.0.0.1"

  azure_default_tags = {
    default = {
      Stage    = "hub",
      Project  = "",
      Client   = "Convolab",
      Cloud    = "public",
      Type     = "resource-group",
      Billing  = "Public",
      Country  = "Thailand",
      Timezone = "p0700",
      Managed  = "terraform",
      Security = "public",
      Product  = "convolab"
    }
  }

  #AKS information 
  aks_cluster_name = "aks-sea-bot-dev-001"
  kubernetes_version = "1.26.6"
  automatic_channel_upgrade = "stable"
  sku_tier = "standard"
  default_node_pool_name = "seabotdev001"
  default_node_pool_vm_size = "Standard_D2_v2"
  default_node_pool_availability_zones = ["1","2","3"]
  default_node_pool_node_labels = {
                            "Enviornment": "DEV",
                            "Project": "Public-Bot"
                        }
  default_node_pool_node_taints = []
  default_node_pool_enable_auto_scaling = true
  default_node_pool_enable_host_encryption = true
  default_node_pool_enable_node_public_ip = false
  default_node_pool_max_pods = 250
  default_node_pool_max_count = 20
  default_node_pool_min_count = 5
  default_node_pool_node_count = 5
  default_node_pool_os_disk_type = "ManagedDisks"
  network_service_cidr = "10.0.0.0/16"
  network_dns_service_ip = "10.0.0.10"
  network_plugin = "kubenet"
  role_based_access_control_enabled = true
  admin_group_object_ids = ["100"]
  azure_rbac_enabled = true
  admin_username = "azureuser"
  keda_enabled = true
  vertical_pod_autoscaler_enabled = true
  image_cleaner_enabled = true
  azure_policy_enabled = true
  http_application_routing_enabled = true
  

  ssh_public_key = "es-ubantuvm1_key"

}



