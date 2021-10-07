terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.48.0"
    }
  }
  backend "azurerm" {
      resource_group_name = "cloud-shell-storage-southeastasia"
      storage_account_name = "storageterra01"
      container_name = "terrablob"
      key = "tf/terraform.tfstate"
}
}

provider "azurerm" {
  features{}
}

module "rg-hub-spoke" {
    source = "./Modules/Resource Group"   
}

module "rg-hub" {
    source = "./Modules/Hub"
    rg_name = module.rg-hub-spoke.rg_module-hub_output
    vnet-spoke = module.rg-spoke.vnet-spoke_output.id
}

module "rg-spoke" {
    source = "./Modules/Spoke"
    rg_name = module.rg-hub-spoke.rg_module-spoke_output
    vnet-hub = module.rg-hub.vnet-hub_output.id
}

output "module_spoke" {
  value = module.rg-spoke.ip_spoke
}

output "module_hub" {
  value = module.rg-hub.ip_hub
}

