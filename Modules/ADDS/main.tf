##########################################################
## Promote VM to be a Domain Controller
##########################################################

// the `exit_code_hack` is to keep the VM Extension resource happy
locals { 
  disable_firewall     = "Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False"
  import_command       = "Import-Module ADDSDeployment"
  password_command     = "$password = ConvertTo-SecureString ${var.admin_password} -AsPlainText -Force"
  install_ad_command   = "Add-WindowsFeature -name ad-domain-services -IncludeManagementTools"
  configure_ad_command = "Install-ADDSForest -CreateDnsDelegation:$false -DomainMode Win2012R2 -DomainName ${var.active_directory_domain} -DomainNetbiosName ${var.active_directory_netbios_name} -ForestMode Win2012R2 -InstallDns:$true -SafeModeAdministratorPassword $password -Force:$true"
  shutdown_command     = "shutdown -r -t 10"
  exit_code_hack       = "exit 0"
  powershell_command   = "${local.disable_firewall}; ${local.import_command}; ${local.password_command}; ${local.install_ad_command}; ${local.configure_ad_command}; ${local.shutdown_command}; ${local.exit_code_hack}"
}

resource "azurerm_virtual_machine_extension" "create-active-directory-forest" {
  name                 = "create-active-directory-forest"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  virtual_machine_id   = var.vm-hub1.id
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe -Command \"${local.powershell_command}\""
    }
SETTINGS
}

resource "azurerm_virtual_network_dns_servers" "update_dns_hub1" {
  virtual_network_id = var.data-vnet-hub1.id
  dns_servers        = [var.data-nic-hub1.private_ip_address]
}

resource "azurerm_virtual_network_dns_servers" "update_dns_spoke1" {
  virtual_network_id = var.data-vnet-spoke1.id
  dns_servers        = [var.data-nic-hub1.private_ip_address]
}

resource "azurerm_virtual_network_dns_servers" "update_dns_spoke2" {
  virtual_network_id = var.data-vnet-spoke2.id
  dns_servers        = [var.data-nic-hub1.private_ip_address]
}