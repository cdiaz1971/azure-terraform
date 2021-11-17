resource "azurerm_subnet" "diaz-bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.diaz-az.name
  virtual_network_name = azurerm_virtual_network.diaz-az-vnet.name
  address_prefixes     = ["10.0.10.0/24"]
}

resource "azurerm_public_ip" "diaz-bastion-ip" {
  name                = "diaz-bastion-ip"
  location            = azurerm_resource_group.diaz-az.location
  resource_group_name = azurerm_resource_group.diaz-az.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "diaz-bastion-host" {
  name                = "diaz-bastion"
  location            = azurerm_resource_group.diaz-az.location
  resource_group_name = azurerm_resource_group.diaz-az.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.diaz-bastion.id
    public_ip_address_id = azurerm_public_ip.diaz-bastion-ip.id
  }
}

