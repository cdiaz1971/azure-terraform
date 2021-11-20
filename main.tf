provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "diaz-az" {
  name     = "diaz-az-rg"
  location = var.location
}

resource "azurerm_virtual_network" "diaz-az-vnet" {
  name                = "diaz-az-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.diaz-az.location
  resource_group_name = azurerm_resource_group.diaz-az.name


}
resource "azurerm_subnet" "diaz-private-01" {
  name                 = "diaz-private_sn-01"
  resource_group_name  = azurerm_resource_group.diaz-az.name
  virtual_network_name = azurerm_virtual_network.diaz-az-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_subnet" "diaz-private-02" {
  name                 = "diaz-private_sn-02"
  resource_group_name  = azurerm_resource_group.diaz-az.name
  virtual_network_name = azurerm_virtual_network.diaz-az-vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}




resource "azurerm_public_ip" "diaz-public_ip-01" {
  name                = "diaz-publicip-01"
  location            = azurerm_resource_group.diaz-az.location
  resource_group_name = azurerm_resource_group.diaz-az.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}
resource "azurerm_network_interface" "diaz-win-01-nic" {
  name                = "diaz-win-01-nic"
  resource_group_name = azurerm_resource_group.diaz-az.name
  location            = azurerm_resource_group.diaz-az.location

  ip_configuration {
    name                 = "ipconfig1"
    primary              = true
    subnet_id            = azurerm_subnet.diaz-private-01.id
    public_ip_address_id = azurerm_public_ip.diaz-public_ip-01.id

    private_ip_address_allocation = "Dynamic"

  }
}

resource "azurerm_network_security_group" "diaz-rdp-sg" {
  location            = azurerm_resource_group.diaz-az.location
  name                = "diaz-az-rdp-sg"
  resource_group_name = azurerm_resource_group.diaz-az.name
  security_rule = [
    {
      access                                     = "Allow"
      description                                = ""
      destination_address_prefix                 = "*"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = "3389"
      destination_port_ranges                    = []
      direction                                  = "Inbound"
      name                                       = "RDP_from_Home"
      priority                                   = 100
      protocol                                   = "TCP"
      source_address_prefix                      = "71.206.46.139/32"
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_range                          = "*"
      source_port_ranges                         = []
    },
  ]
  tags = {}

  timeouts {}
}

resource "azurerm_network_interface_security_group_association" "diaz-private-nicsg" {
  network_interface_id      = azurerm_network_interface.diaz-win-01-nic.id
  network_security_group_id = azurerm_network_security_group.diaz-rdp-sg.id


}


resource "azurerm_windows_virtual_machine" "diaz-win-01" {
  name                = "diaz-win-01"
  resource_group_name = azurerm_resource_group.diaz-az.name
  location            = azurerm_resource_group.diaz-az.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password      = var.adminpwd
  network_interface_ids = [
    azurerm_network_interface.diaz-win-01-nic.id,
  ]

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter-smalldisk"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
    name                 = "diaz-win-01-cdrive"
    #disk_size_gb         = 127
  }
}
