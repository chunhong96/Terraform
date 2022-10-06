// Route Table 1

resource "azurerm_route_table" "route1" {
  name                          = "rt-fw"
  location                      = var.rg-location
  resource_group_name           = var.rg-name-hub1
  disable_bgp_route_propagation = false
}

resource "azurerm_route" "route1-rt2" {
  name                = "rt-fwtoint"
  resource_group_name = var.rg-name-hub1
  route_table_name    = azurerm_route_table.route1.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = var.data-fw.ip_configuration.0.private_ip_address
}

resource "azurerm_subnet_route_table_association" "rt-subnet1-associate" {
  subnet_id      = var.snet-hub1-vm.id
  route_table_id = azurerm_route_table.route1.id
  depends_on     = [azurerm_route_table.route1]
}


//Route Table 2 (Spoke to Spoke)

resource "azurerm_route_table" "route2" {
  name                          = "rt-vgw"
  location                      = var.rg-location
  resource_group_name           = var.rg-name-hub1
  disable_bgp_route_propagation = false
}

resource "azurerm_route" "route2-rt1" {
  name                = "rt-spoke1tospoke2"
  resource_group_name = var.rg-name-hub1
  route_table_name    = azurerm_route_table.route2.name
  address_prefix      = "31.0.1.0/24"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = "11.0.2.4"
}

resource "azurerm_route" "route2-rt2" {
  name                = "rt-spoke2tospoke1"
  resource_group_name = var.rg-name-hub1
  route_table_name    = azurerm_route_table.route2.name
  address_prefix      = "21.0.1.0/24"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = "11.0.2.4"
}

resource "azurerm_route" "route2-rt3" {
  name                = "rt-fwtoint"
  resource_group_name = var.rg-name-hub1
  route_table_name    = azurerm_route_table.route2.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = var.data-fw.ip_configuration.0.private_ip_address
}

resource "azurerm_route" "route2-rt4" {
  name                = "rt-to-agw"
  resource_group_name = var.rg-name-hub1
  route_table_name    = azurerm_route_table.route2.name
  address_prefix      = "11.0.3.0/24"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = var.data-fw.ip_configuration.0.private_ip_address
}

resource "azurerm_subnet_route_table_association" "rt2-spoke1-associate" {
  subnet_id      = var.snet-spoke1-vm.id
  route_table_id = azurerm_route_table.route2.id
  depends_on     = [azurerm_route_table.route2]
}

resource "azurerm_subnet_route_table_association" "rt2-spoke2-associate" {
  subnet_id      = var.snet-spoke2-vm.id
  route_table_id = azurerm_route_table.route2.id
  depends_on     = [azurerm_route_table.route2]
}

//Route Table 3 (Application Gateway)

resource "azurerm_route_table" "route3" {
  name                          = "rt-agw"
  location                      = var.rg-location
  resource_group_name           = var.rg-name-hub1
  disable_bgp_route_propagation = false
}

resource "azurerm_route" "route3-rt1" {
  name                = "rt-fw-spoke1"
  resource_group_name = var.rg-name-hub1
  route_table_name    = azurerm_route_table.route3.name
  address_prefix      = "21.0.1.0/24"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = "11.0.1.4"
}

resource "azurerm_route" "route3-rt2" {
  name                = "rt-fw-spoke2"
  resource_group_name = var.rg-name-hub1
  route_table_name    = azurerm_route_table.route3.name
  address_prefix      = "31.0.1.0/24"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = "11.0.1.4"
}

resource "azurerm_subnet_route_table_association" "rt3-agw-associate" {
  subnet_id      = var.snet-agw.id
  route_table_id = azurerm_route_table.route3.id
  depends_on     = [azurerm_route_table.route3]
}