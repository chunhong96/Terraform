resource "azurerm_virtual_network" "vnet-firewall" {
  name                = "vnet-firewall"
  address_space       = ["10.2.0.0/16"]
  location            = var.rg_name.location
  resource_group_name = var.rg_name.name
}

resource "azurerm_subnet" "subnet-firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.rg_name.name
  virtual_network_name = azurerm_virtual_network.vnet-firewall.name
  address_prefixes     = ["10.2.0.0/24"]
}

resource "azurerm_public_ip" "ip-firewall" {
  name                = "pip-fw"
  location            = var.rg_name.location
  resource_group_name = var.rg_name.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "hub-firewall" {
  name                = "hub-firewall"
  location            = var.rg_name.location
  resource_group_name = var.rg_name.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet-firewall.id
    public_ip_address_id = azurerm_public_ip.ip-firewall.id
  }
}

resource "azurerm_firewall_nat_rule_collection" "nat-rule-1" {
  name                = "rdp_allow"
  azure_firewall_name = azurerm_firewall.hub-firewall.name
  resource_group_name = var.rg_name.name
  priority            = 100
  action              = "Dnat"

  rule {
    name = "rdp-hub"

    source_addresses = [
      "0.0.0.0/0",
    ]

    destination_ports = [
      "3389",
    ]

    destination_addresses = [
      azurerm_public_ip.ip-firewall.ip_address
    ]

    translated_port = 3389

    translated_address = var.vm-hub.private_ip_address

    protocols = [
      "TCP",
      "UDP",
    ]
  }
}

resource "azurerm_virtual_network_peering" "peer_fw" {
  name                      = "peerhubtofw"
  resource_group_name       = var.rg_name.name
  virtual_network_name      = azurerm_virtual_network.vnet-firewall.name
  remote_virtual_network_id = var.vnet-hub.id
}