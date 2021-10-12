output "rg_module-hub_output" {

    value = {
        name = azurerm_resource_group.rg-hub.name
        location = azurerm_resource_group.rg-hub.location
    }
}

output "rg_module-spoke_output" {

    value = {
        name = azurerm_resource_group.rg-spoke.name
        location = azurerm_resource_group.rg-spoke.location
    }
}

output "rg_module-firewall_output" {

    value = {
        name = azurerm_resource_group.rg-firewall.name
        location = azurerm_resource_group.rg-firewall.location
    }
}