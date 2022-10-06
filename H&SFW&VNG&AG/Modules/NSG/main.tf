// NSG1

resource "azurerm_network_security_group" "nsg-hub1" {
  name                = "nsg-hub1"
  location            = var.rg-location
  resource_group_name = var.rg-name-hub1
}

resource "azurerm_network_security_rule" "rule-RDP1" {
  name                        = "Allow_RDP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "3389"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg-name-hub1
  network_security_group_name = azurerm_network_security_group.nsg-hub1.name
}

resource "azurerm_network_security_rule" "rule-HTTPS1" {
  name                        = "Allow_HTTPS"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "443"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg-name-hub1
  network_security_group_name = azurerm_network_security_group.nsg-hub1.name
}

resource "azurerm_network_security_rule" "rule-HTTP1" {
  name                        = "Allow_HTTP"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "80"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg-name-hub1
  network_security_group_name = azurerm_network_security_group.nsg-hub1.name
}

resource "azurerm_network_security_rule" "rule-PING1" {
  name                        = "Allow_PING"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg-name-hub1
  network_security_group_name = azurerm_network_security_group.nsg-hub1.name
}

resource "azurerm_network_interface_security_group_association" "associate-nsg-nic-hub1" {
  network_interface_id      = var.nic-hub1.id
  network_security_group_id = azurerm_network_security_group.nsg-hub1.id
  depends_on          = [var.vm-hub1]
}

// NSG2

resource "azurerm_network_security_group" "nsg-spoke1" {
  name                = "nsg-spoke1"
  location            = var.rg-location
  resource_group_name = var.rg-name-spoke1
}

resource "azurerm_network_security_rule" "rule-RDP2" {
  name                        = "Allow_RDP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "3389"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg-name-spoke1
  network_security_group_name = azurerm_network_security_group.nsg-spoke1.name
}

resource "azurerm_network_security_rule" "rule-HTTPS2" {
  name                        = "Allow_HTTPS"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "443"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg-name-spoke1
  network_security_group_name = azurerm_network_security_group.nsg-spoke1.name
}

resource "azurerm_network_security_rule" "rule-HTTP2" {
  name                        = "Allow_HTTP"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "80"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg-name-spoke1
  network_security_group_name = azurerm_network_security_group.nsg-spoke1.name
}

resource "azurerm_network_security_rule" "rule-PING2" {
  name                        = "Allow_PING"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg-name-spoke1
  network_security_group_name = azurerm_network_security_group.nsg-spoke1.name
}

resource "azurerm_network_interface_security_group_association" "associate-nsg-nic-spoke1" {
  network_interface_id      = var.nic-spoke1.id
  network_security_group_id = azurerm_network_security_group.nsg-spoke1.id
  depends_on          = [var.vm-spoke1]
}

// NSG3

resource "azurerm_network_security_group" "nsg-spoke2" {
  name                = "nsg-spoke2"
  location            = var.rg-location
  resource_group_name = var.rg-name-spoke2
}

resource "azurerm_network_security_rule" "rule-RDP3" {
  name                        = "Allow_RDP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "3389"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg-name-spoke2
  network_security_group_name = azurerm_network_security_group.nsg-spoke2.name
}

resource "azurerm_network_security_rule" "rule-HTTPS3" {
  name                        = "Allow_HTTPS"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "443"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg-name-spoke2
  network_security_group_name = azurerm_network_security_group.nsg-spoke2.name
}

resource "azurerm_network_security_rule" "rule-HTTP3" {
  name                        = "Allow_HTTP"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "80"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg-name-spoke2
  network_security_group_name = azurerm_network_security_group.nsg-spoke2.name
}

resource "azurerm_network_security_rule" "rule-PING3" {
  name                        = "Allow_PING"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg-name-spoke2
  network_security_group_name = azurerm_network_security_group.nsg-spoke2.name
}

resource "azurerm_network_interface_security_group_association" "associate-nsg-nic-spoke2" {
  network_interface_id      = var.nic-spoke2.id
  network_security_group_id = azurerm_network_security_group.nsg-spoke2.id
  depends_on          = [var.vm-spoke2]
}