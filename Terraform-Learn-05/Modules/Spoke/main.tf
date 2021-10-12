resource "azurerm_virtual_network" "vnet-spoke" {
    name = "vnet-spoke-01"
    address_space = ["10.1.0.0/16"]
    location = var.rg_name.location
    resource_group_name = var.rg_name.name
}

# Create subnet
resource "azurerm_subnet" "subnet-spoke" {
  name                 = "subnet-spoke"
  resource_group_name  = var.rg_name.name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = ["10.1.0.0/24"]
}

# Create public IP
resource "azurerm_public_ip" "publicip" {
  name                = "ip-spoke"
  location            = var.rg_name.location
  resource_group_name = var.rg_name.name
  allocation_method   = "Static"
}


# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-spoke"
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

resource "azurerm_network_interface_security_group_association" "associate-nsg-nic" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on          = [azurerm_virtual_machine.vm]
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                      = "nic-spoke"
  location                  = var.rg_name.location
  resource_group_name       = var.rg_name.name

  ip_configuration {
    name                          = "myNICConfg"
    subnet_id                     = azurerm_subnet.subnet-spoke.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

# Create a Windows virtual machine
resource "azurerm_virtual_machine" "vm" {
  name                  = "vm-spoke"
  location              = var.rg_name.location
  resource_group_name   = var.rg_name.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "OsDisk-spoke"
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
    computer_name  = "os-spoke"
    admin_username = "acc1"
    admin_password = "Password_1234"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = false
  }
}


resource "azurerm_virtual_network_peering" "peer_spoke" {
  name                      = "peerspoketohub"
  resource_group_name       = var.rg_name.name
  virtual_network_name      = azurerm_virtual_network.vnet-spoke.name
  remote_virtual_network_id = var.vnet-hub.id
}

data "azurerm_public_ip" "ip" {
  name                = azurerm_public_ip.publicip.name
  resource_group_name = var.rg_name.name
  depends_on          = [azurerm_virtual_machine.vm]
}

