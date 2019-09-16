resource "azurerm_kubernetes_cluster" "kumpf" {
  name                = var.cluster_name
  location            = azurerm_resource_group.kumpf.location
  resource_group_name = azurerm_resource_group.kumpf.name
  dns_prefix          = var.cluster_name

  agent_pool_profile {
    name            = "default"
    count           = 1
    vm_size         = "Standard_D1_v2"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  tags = {
    Environment = "Production"
  }
}
