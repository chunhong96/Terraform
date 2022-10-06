
output "vm-hub1" {
    value = azurerm_windows_virtual_machine.vm-hub1
}

output "vm-spoke1" {
    value = azurerm_windows_virtual_machine.vm-spoke1
}

output "vm-spoke2" {
    value = azurerm_windows_virtual_machine.vm-spoke2
}

output "nic-hub1" {
    value = azurerm_network_interface.nic-hub1
}

output "nic-spoke1" {
    value = azurerm_network_interface.nic-spoke1
}

output "nic-spoke2" {
    value = azurerm_network_interface.nic-spoke2
}

output "data-nic-hub1" {
    value = data.azurerm_network_interface.data-nic-hub1
}
