output "snet-hub1-vm" {
    value = azurerm_subnet.snet-hub1-vm
}

output "snet-spoke1-vm" {
    value = azurerm_subnet.snet-spoke1-vm
}

output "snet-spoke2-vm" {
    value = azurerm_subnet.snet-spoke2-vm
}

output "snet-fw" {
    value = azurerm_subnet.snet-fw
}

output "snet-vgw" {
    value = azurerm_subnet.snet-vgw
}

output "snet-agw" {
    value = azurerm_subnet.snet-agw
}

output "data-vnet-hub1" {
    value = data.azurerm_virtual_network.data-vnet-hub1
}

output "data-vnet-spoke1" {
    value = data.azurerm_virtual_network.data-vnet-spoke1
}

output "data-vnet-spoke2" {
    value = data.azurerm_virtual_network.data-vnet-spoke2
}
