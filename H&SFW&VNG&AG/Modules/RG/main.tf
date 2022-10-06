resource "azurerm_resource_group" "rg-hub1" {
  name     = var.RG1.name
  location = var.rg-location
}

resource "azurerm_resource_group" "rg-spoke1" {
  name     = var.RG2.name
  location = var.rg-location
}

resource "azurerm_resource_group" "rg-spoke2" {
  name     = var.RG3.name
  location = var.rg-location
}