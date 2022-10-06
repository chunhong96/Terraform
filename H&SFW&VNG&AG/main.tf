terraform {
  required_version = ">= 1.0.0"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 3.3.0"
    }
  }

  // Remote State File in Azure Blob Storage
  backend "azurerm" {}
}

provider "azurerm" {
    features{}
    subscription_id = var.subscriptionid
    tenant_id       = var.tenantid
}

module "rg" {
    source = "./Modules/RG"
    rghubname = var.rghubname
    rgspoke1name = var.rgspoke1name
    rgspoke2name = var.rgspoke2name
    rg-location = var.rg-location
}

module "vnet" {
    source = "./Modules/VNet"
    rg-name-hub1 = module.rg.rg-hub1-name
    rg-name-spoke1 = module.rg.rg-spoke1-name
    rg-name-spoke2 = module.rg.rg-spoke2-name
    rg-location = var.rg-location
}

module "nsg" {
    source = "./Modules/NSG"
    rg-name-hub1 = module.rg.rg-hub1-name
    rg-name-spoke1 = module.rg.rg-spoke1-name
    rg-name-spoke2 = module.rg.rg-spoke2-name
    rg-location = var.rg-location
    vm-hub1 = module.vm.vm-hub1
    vm-spoke1 = module.vm.vm-spoke1
    vm-spoke2 = module.vm.vm-spoke2
    nic-hub1 = module.vm.nic-hub1
    nic-spoke1 = module.vm.nic-spoke1
    nic-spoke2 = module.vm.nic-spoke2
}

module "vm" {
    source = "./Modules/VM"
    rg-name-hub1 = module.rg.rg-hub1-name
    rg-name-spoke1 = module.rg.rg-spoke1-name
    rg-name-spoke2 = module.rg.rg-spoke2-name
    rg-location = var.rg-location
    snet-hub1-vm = module.vnet.snet-hub1-vm
    snet-spoke1-vm = module.vnet.snet-spoke1-vm
    snet-spoke2-vm = module.vnet.snet-spoke2-vm
    
}

module "fw" {
    source = "./Modules/FW"
    rg-name-hub1 = module.rg.rg-hub1-name
    rg-location = var.rg-location
    snet-fw = module.vnet.snet-fw
    data-fw = module.fw.data-fw
    pip-fw = module.fw.pip-fw
}

module "vgw" {
    source = "./Modules/VGW"
    rg-name-hub1 = module.rg.rg-hub1-name
    snet-vgw = module.vnet.snet-vgw
    rg-location = var.rg-location
}

module "rt" {
    source = "./Modules/RT"
    rg-name-hub1 = module.rg.rg-hub1-name
    rg-location = var.rg-location
    data-fw = module.fw.data-fw
    data-vgw = module.vgw.data-vgw
    snet-hub1-vm = module.vnet.snet-hub1-vm
    snet-spoke1-vm = module.vnet.snet-spoke1-vm
    snet-spoke2-vm = module.vnet.snet-spoke2-vm
    snet-agw = module.vnet.snet-agw
    snet-fw = module.vnet.snet-fw
    depends_on = [module.vgw]
}

module "ag" {
    source = "./Modules/AG"
    rg-name-hub1 = module.rg.rg-hub1-name
    rg-location = var.rg-location
    snet-agw = module.vnet.snet-agw
    pip-fw = module.fw.pip-fw
}

module "adds" {
    source = "./Modules/ADDS"
    active_directory_domain = var.ad-domainname
    admin_password = var.ad-adminpassword
    active_directory_netbios_name = var.ad-netbiosname
    vm-hub1 = module.vm.vm-hub1
    virtual_machine_id = module.vm.vm-hub1.id
    vmname = module.vm.vm-hub1.name
    data-vnet-hub1 = module.vnet.data-vnet-hub1
    data-vnet-spoke1 = module.vnet.data-vnet-spoke1
    data-vnet-spoke2 = module.vnet.data-vnet-spoke2
    data-nic-hub1 = module.vm.data-nic-hub1
    depends_on = [module.vgw]
}
 
module "adjoin" {
    source = "./Modules/ADJOIN"
    vm-spoke1 = module.vm.vm-spoke1
    vm-spoke2 = module.vm.vm-spoke2
    active_directory_domain = var.ad-domainname
    active_directory_username = var.ad-username
    active_directory_password = var.ad-password
    depends_on = [module.iis, module.adds, module.ag]
}

module "iis" {
    source = "./Modules/IIS"
    vm-spoke1 = module.vm.vm-spoke1
    vm-spoke2 = module.vm.vm-spoke2
    depends_on = [module.adds]
}

