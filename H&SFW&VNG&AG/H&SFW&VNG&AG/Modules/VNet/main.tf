// Virtual Network - Hub

resource "azurerm_virtual_network" "vnet-hub1" {
  name                = "vnet-hub-01"
  address_space       = ["11.0.0.0/16"]
  location            = var.rg-location
  resource_group_name = var.rg-name-hub1
}

resource "azurerm_subnet" "snet-fw" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.rg-name-hub1
  virtual_network_name = azurerm_virtual_network.vnet-hub1.name
  address_prefixes     = ["11.0.1.0/24"]
}

resource "azurerm_subnet" "snet-vgw" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.rg-name-hub1
  virtual_network_name = azurerm_virtual_network.vnet-hub1.name
  address_prefixes     = ["11.0.2.0/24"]
}

resource "azurerm_subnet" "snet-agw" {
  name                 = "ApplicationGatewaySubnet"
  resource_group_name  = var.rg-name-hub1
  virtual_network_name = azurerm_virtual_network.vnet-hub1.name
  address_prefixes     = ["11.0.3.0/24"]
}

resource "azurerm_subnet" "snet-hub1-vm" {
  name                 = "snet-hub-vms"
  resource_group_name  = var.rg-name-hub1
  virtual_network_name = azurerm_virtual_network.vnet-hub1.name
  address_prefixes     = ["11.0.0.0/24"]
}

data "azurerm_virtual_network" "data-vnet-hub1" {
  name                = azurerm_virtual_network.vnet-hub1.name
  resource_group_name = var.rg-name-hub1
}


// Virtual Network - Spoke1

resource "azurerm_virtual_network" "vnet-spoke1" {
  name                = "vnet-spoke1-01"
  address_space       = ["21.0.0.0/16"]
  location            = var.rg-location
  resource_group_name = var.rg-name-spoke1
}

resource "azurerm_subnet" "snet-spoke1-vm" {
  name                 = "snet-spoke1-vms"
  resource_group_name  = var.rg-name-spoke1
  virtual_network_name = azurerm_virtual_network.vnet-spoke1.name
  address_prefixes     = ["21.0.1.0/24"]
}

data "azurerm_virtual_network" "data-vnet-spoke1" {
  name                = azurerm_virtual_network.vnet-spoke1.name
  resource_group_name = var.rg-name-spoke1
}


// Virtual Network - Spoke2

resource "azurerm_virtual_network" "vnet-spoke2" {
  name                = "vnet-spoke2-01"
  address_space       = ["31.0.0.0/16"]
  location            = var.rg-location
  resource_group_name = var.rg-name-spoke2
}

resource "azurerm_subnet" "snet-spoke2-vm" {
  name                 = "snet-spoke2-vms"
  resource_group_name  = var.rg-name-spoke2
  virtual_network_name = azurerm_virtual_network.vnet-spoke2.name
  address_prefixes     = ["31.0.1.0/24"]
}

data "azurerm_virtual_network" "data-vnet-spoke2" {
  name                = azurerm_virtual_network.vnet-spoke2.name
  resource_group_name = var.rg-name-spoke2
}


// Virtual Network - Hub1toSpoke1 - Peering

resource "azurerm_virtual_network_peering" "hub1-spoke1" {
  name                      = "peer-hub1-to-spoke1"
  resource_group_name       = var.rg-name-hub1
  virtual_network_name      = azurerm_virtual_network.vnet-hub1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-spoke1.id
  allow_gateway_transit     = true
  allow_forwarded_traffic   = true
}

// Virtual Network - Spoke1toHub1 - Peering

resource "azurerm_virtual_network_peering" "spoke1-hub1" {
  name                      = "peer-spoke1-to-hub1"
  resource_group_name       = var.rg-name-spoke1
  virtual_network_name      = azurerm_virtual_network.vnet-spoke1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-hub1.id
  allow_gateway_transit     = false
  allow_forwarded_traffic   = true
}

// Virtual Network - Hub1toSpoke2 - Peering

resource "azurerm_virtual_network_peering" "hub1-spoke2" {
  name                      = "peer-hub1-to-spoke2"
  resource_group_name       = var.rg-name-hub1
  virtual_network_name      = azurerm_virtual_network.vnet-hub1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-spoke2.id
  allow_gateway_transit     = true
  allow_forwarded_traffic   = true
}

// Virtual Network - Spoke2toHub1 - Peering

resource "azurerm_virtual_network_peering" "spoke2-hub1" {
  name                      = "peer-spoke2-to-hub1"
  resource_group_name       = var.rg-name-spoke2
  virtual_network_name      = azurerm_virtual_network.vnet-spoke2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-hub1.id
  allow_gateway_transit     = false
  allow_forwarded_traffic   = true
}




