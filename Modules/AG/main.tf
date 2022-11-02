locals {
  backend_address_pool_name      = "beap1"
  frontend_port_name             = "feport1"
  frontend_ip_configuration_name = "feip"
  http_setting_name              = "be-htst"
  listener_name                  = "httplstn"
  request_routing_rule_name      = "rqrt"
  redirect_configuration_name    = "rdrcfg"
}

resource "azurerm_public_ip" "pip-agw" {
  name                = "pip-agw"
  location            = var.rg-location
  resource_group_name = var.rg-name-hub1
  allocation_method   = "Dynamic"
}

resource "azurerm_application_gateway" "hub-agw" {
  name                = "agw1"
  location            = var.rg-location
  resource_group_name = var.rg-name-hub1

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.snet-agw.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip-agw.id
  }

  backend_address_pool {
    name          = local.backend_address_pool_name
    ip_addresses  = ["31.0.1.4"]
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = ""
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}