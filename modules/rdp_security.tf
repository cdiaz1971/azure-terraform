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