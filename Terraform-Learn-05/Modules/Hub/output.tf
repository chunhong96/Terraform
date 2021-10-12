output "vnet-hub_output" {
    value = {
        id = azurerm_virtual_network.vnet-hub.id
        name = azurerm_virtual_network.vnet-hub.name
    }
}

output "ip_hub" {
  value = data.azurerm_public_ip.ip.ip_address
}

output "vmname_hub_output" {
  value = azurerm_virtual_machine.vm.name
}

output "nic_hub_output" {
  value = data.azurerm_network_interface.nic
}