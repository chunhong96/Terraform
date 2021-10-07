output "vnet-hub_output" {
    value = {
        id = azurerm_virtual_network.vnet-hub.id
    }
}

output "ip_hub" {
  value = data.azurerm_public_ip.ip.ip_address
}