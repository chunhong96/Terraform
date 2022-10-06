resource "azurerm_resource_group" "rg-hub1" {
  name     = var.rghubname
  location = var.rg-location
}

resource "azurerm_resource_group" "rg-spoke1" {
  name     = var.rgspoke1name
  location = var.rg-location
}

resource "azurerm_resource_group" "rg-spoke2" {
  name     = var.rgspoke2name
  location = var.rg-location
}