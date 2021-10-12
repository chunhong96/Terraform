resource "azurerm_resource_group" "rg-hub" {
    name = var.rg-hub.name
    location = var.rg-hub.location
}

resource "azurerm_resource_group" "rg-spoke" {
    name = var.rg-spoke.name
    location = var.rg-spoke.location
}

resource "azurerm_resource_group" "rg-firewall" {
    name = var.rg-firewall.name
    location = var.rg-firewall.location
}