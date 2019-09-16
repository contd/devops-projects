provider "azurerm" {
  version = "=1.28.0"

  subscription_id             = var.subscription_id
  tenant_id                   = var.tenant_id
  client_certificate_path     = var.client_certificate_path
  client_certificate_password = var.client_certificate_password
  client_id                   = var.client_id
}

provider "kubernetes" {}
provider "helm" {}

/*
provider "kubernetes" {
  host                   = "${azurerm_kubernetes_cluster.kumpf.kube_config.0.host}"
  username               = "${azurerm_kubernetes_cluster.kumpf.kube_config.0.username}"
  password               = "${azurerm_kubernetes_cluster.kumpf.kube_config.0.password}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.kumpf.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.kumpf.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.kumpf.kube_config.0.cluster_ca_certificate)}"
}

export ARM_CLIENT_ID="f5645785-5ffb-4268-9cd2-d81953fce953"
export ARM_CLIENT_CERTIFICATE_PATH="`pwd`/service-principal.pfx"
export ARM_CLIENT_CERTIFICATE_PASSWORD=""
export ARM_SUBSCRIPTION_ID="fa5db9b5-6fc5-4454-9896-1cdf7e0ebb6e"
export ARM_TENANT_ID="79983fd4-ada9-4b53-ac41-c89e6ca08c6c"
*/
