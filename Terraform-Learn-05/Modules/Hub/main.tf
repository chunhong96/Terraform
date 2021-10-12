resource "azurerm_virtual_network" "vnet-hub" {
    name = "vnet-hub-01"
    address_space = ["10.0.0.0/16"]
    location = var.rg_name.location
    resource_group_name = var.rg_name.name
}

# Create subnet
resource "azurerm_subnet" "subnet-hub" {
  name                 = "subnet-hub"
  resource_group_name  = var.rg_name.name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Create public IP
resource "azurerm_public_ip" "publicip" {
  name                = "ip-hub"
  location            = var.rg_name.location
  resource_group_name = var.rg_name.name
  allocation_method   = "Static"
}


# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-hub"
  location            = var.rg_name.location
  resource_group_name = var.rg_name.name
}

resource "azurerm_network_security_rule" "nsg-rule"{
    network_security_group_name = azurerm_network_security_group.nsg.name
    resource_group_name = var.rg_name.name
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "nsg-rule2"{
    network_security_group_name = azurerm_network_security_group.nsg.name
    resource_group_name = var.rg_name.name
    name                       = "Ping"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "ICMP"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
}


# Create network interface
resource "azurerm_network_interface" "nic" {
  name                      = "nic-hub"
  location                  = var.rg_name.location
  resource_group_name       = var.rg_name.name

  ip_configuration {
    name                          = "myNICConfg"
    subnet_id                     = azurerm_subnet.subnet-hub.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

resource "azurerm_network_interface_security_group_association" "associate-nsg-nic" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id  
  depends_on          = [azurerm_virtual_machine.vm]
}

# Create a Windows virtual machine
resource "azurerm_virtual_machine" "vm" {
  name                  = "vm-hub"
  location              = var.rg_name.location
  resource_group_name   = var.rg_name.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "OsDisk-hub"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_profile {
    computer_name  = "os-hub"
    admin_username = "acc1"
    admin_password = "Password_1234"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = false
  }

}

##########################################################
## Promote VM to be a Domain Controller
##########################################################

// the `exit_code_hack` is to keep the VM Extension resource happy
locals { 
  import_command       = "Import-Module ADDSDeployment"
  password_command     = "$password = ConvertTo-SecureString ${var.admin_password} -AsPlainText -Force"
  install_ad_command   = "Add-WindowsFeature -name ad-domain-services -IncludeManagementTools"
  configure_ad_command = "Install-ADDSForest -CreateDnsDelegation:$false -DomainMode Win2012R2 -DomainName ${var.active_directory_domain} -DomainNetbiosName ${var.active_directory_netbios_name} -ForestMode Win2012R2 -InstallDns:$true -SafeModeAdministratorPassword $password -Force:$true"
  shutdown_command     = "shutdown -r -t 10"
  exit_code_hack       = "exit 0"
  powershell_command   = "${local.import_command}; ${local.password_command}; ${local.install_ad_command}; ${local.configure_ad_command}; ${local.shutdown_command}; ${local.exit_code_hack}"
}

resource "azurerm_virtual_machine_extension" "create-active-directory-forest" {
  name                 = "create-active-directory-forest"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  virtual_machine_id = azurerm_virtual_machine.vm.id
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe -Command \"${local.powershell_command}\""
    }
SETTINGS
}

resource "azurerm_virtual_network_peering" "peer_hub" {
  name                      = "peerhubtospoke"
  resource_group_name       = var.rg_name.name
  virtual_network_name      = azurerm_virtual_network.vnet-hub.name
  remote_virtual_network_id = var.vnet-spoke.id
}

data "azurerm_public_ip" "ip" {
  name                = azurerm_public_ip.publicip.name
  resource_group_name = var.rg_name.name
  depends_on          = [azurerm_virtual_machine.vm]
}

data "azurerm_network_interface" "nic" {
  name                = azurerm_network_interface.nic.name
  resource_group_name = var.rg_name.name
  depends_on          = [azurerm_virtual_machine.vm]
}
