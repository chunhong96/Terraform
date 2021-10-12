output "vnet-spoke_output" {
    value = {
        id = azurerm_virtual_network.vnet-spoke.id
    }
}

output "ip_spoke" {
  value = data.azurerm_public_ip.ip.ip_address
}