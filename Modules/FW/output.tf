output "data-fw" {
  value = data.azurerm_firewall.fw-data
}

output "pip-fw" {
  value = data.azurerm_public_ip.pip-fw
}