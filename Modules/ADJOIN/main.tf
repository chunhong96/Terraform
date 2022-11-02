##########################################################
## Join VM to Active Directory Domain
##########################################################

resource "azurerm_virtual_machine_extension" "join-domain-spoke1" {
  name                 = "join-domain-spoke1"
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  virtual_machine_id   = var.vm-spoke1.id
  type_handler_version = "1.3"
  

  # NOTE: the `OUPath` field is intentionally blank, to put it in the Computers OU
  settings = <<SETTINGS
    {
        "Name": "${var.active_directory_domain}",
        "OUPath": "",
        "User": "${var.active_directory_domain}\\${var.active_directory_username}",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS

  protected_settings = <<SETTINGS
    {
        "Password": "${var.active_directory_password}"
    }
SETTINGS
}

resource "azurerm_virtual_machine_extension" "join-domain-spoke2" {
  name                 = "join-domain-spoke1"
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  virtual_machine_id   = var.vm-spoke2.id
  type_handler_version = "1.3"
  

  # NOTE: the `OUPath` field is intentionally blank, to put it in the Computers OU
  settings = <<SETTINGS
    {
        "Name": "${var.active_directory_domain}",
        "OUPath": "",
        "User": "${var.active_directory_domain}\\${var.active_directory_username}",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS

  protected_settings = <<SETTINGS
    {
        "Password": "${var.active_directory_password}"
    }
SETTINGS
}