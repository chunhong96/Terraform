terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tfstate" {
  name     = var.rg-name
  location = var.rg-location
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "${var.strgname}${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate" {
  name                  = var.strgcontainer
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}

data "azurerm_storage_account" "tfstate" {
  name = azurerm_storage_account.tfstate.name
  resource_group_name      = azurerm_resource_group.tfstate.name
}

data "azurerm_storage_container" "tfstate" {
  storage_account_name = azurerm_storage_account.tfstate.name
  name = azurerm_storage_container.tfstate.name
}

output "storage_access_key" {
  value = data.azurerm_storage_account.tfstate.primary_access_key
  sensitive = true
}

output "storage_account_name" {
  value = data.azurerm_storage_account.tfstate.name
}

output "storage_container_name" {
  value = data.azurerm_storage_container.tfstate.name
}