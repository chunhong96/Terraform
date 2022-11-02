//VM1

resource "azurerm_network_interface" "nic-hub1" {
  name                = "nic-hub1"
  location            = var.rg-location
  resource_group_name = var.rg-name-hub1
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.snet-hub1-vm.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm-hub1" {
  name                = "vm-hub1"
  location            = var.rg-location
  resource_group_name = var.rg-name-hub1
  size                = "Standard_DS1_v2"
  admin_username      = "acc1"
  admin_password      = "Password_1234"
  network_interface_ids = [
    azurerm_network_interface.nic-hub1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

//VM2

resource "azurerm_network_interface" "nic-spoke1" {
  name                = "nic-spoke1"
  location            = var.rg-location
  resource_group_name = var.rg-name-spoke1

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.snet-spoke1-vm.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm-spoke1" {
  name                = "vm-spoke1"
  location            = var.rg-location
  resource_group_name = var.rg-name-spoke1
  size                = "Standard_DS1_v2"
  admin_username      = "acc1"
  admin_password      = "Password_1234"
  network_interface_ids = [
    azurerm_network_interface.nic-spoke1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

//VM3

resource "azurerm_network_interface" "nic-spoke2" {
  name                = "nic-spoke2"
  location            = var.rg-location
  resource_group_name = var.rg-name-spoke2

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.snet-spoke2-vm.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm-spoke2" {
  name                = "vm-spoke2"
  location            = var.rg-location
  resource_group_name = var.rg-name-spoke2
  size                = "Standard_DS1_v2"
  admin_username      = "acc1"
  admin_password      = "Password_1234"
  network_interface_ids = [
    azurerm_network_interface.nic-spoke2.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

  data "azurerm_network_interface" "data-nic-hub1" {
    name                = azurerm_network_interface.nic-hub1.name
    resource_group_name = var.rg-name-hub1
  }
