resource "azurerm_public_ip" "pip-vgw" {
  name                = "pip-vgw-01"
  location            = var.rg-location
  resource_group_name = var.rg-name-hub1

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "vgw" {
  name                = "vgw-01"
  location            = var.rg-location
  resource_group_name = var.rg-name-hub1

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.pip-vgw.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.snet-vgw.id
  }
}

data "azurerm_virtual_network_gateway" "vgw-data" {
  name = azurerm_virtual_network_gateway.vgw.name
  resource_group_name = var.rg-name-hub1
}
