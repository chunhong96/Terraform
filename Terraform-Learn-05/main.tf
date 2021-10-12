terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.48.0"
    }
  }
  backend "azurerm" {
      resource_group_name = "learn"
      storage_account_name = "storageterra01"
      container_name = "terrablob2"
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
    vnet-spoke = module.rg-spoke.vnet-spoke_output
    active_directory_domain = "epsilon3011.org"
    active_directory_netbios_name = "epsilon3011"
    admin_password = "Password_1234"
    
}

module "rg-spoke" {
    source = "./Modules/Spoke"
    rg_name = module.rg-hub-spoke.rg_module-spoke_output
    vnet-hub = module.rg-hub.vnet-hub_output
}

module "rg-firewall" {
    source = "./Modules/Firewall"
    rg_name = module.rg-hub-spoke.rg_module-firewall_output
    rg_name_hub = module.rg-hub-spoke.rg_module-hub_output
    vnet-hub = module.rg-hub.vnet-hub_output
    vm-hub = module.rg-hub.nic_hub_output
}

output "module_spoke" {
  value = module.rg-spoke.ip_spoke
}

output "module_hub" {
  value = module.rg-hub.ip_hub
}

output "module_fw" {
  value = module.rg-hub.nic_hub_output
}
