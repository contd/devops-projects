# Create a resource group
resource "azurerm_resource_group" "kumpf" {
  name     = "production"
  location = var.location
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "kumpf" {
  name                = "production-network"
  resource_group_name = azurerm_resource_group.kumpf.name
  location            = azurerm_resource_group.kumpf.location
  address_space       = ["10.0.0.0/16"]
}
