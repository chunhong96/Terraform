resource "azurerm_public_ip" "pip-fw" {
  name                = "pip-fw-01"
  location            = var.rg-location
  resource_group_name = var.rg-name-hub1
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall_policy" "fw-policy" {
  name                = "fw-policy-01"
  location            = var.rg-location
  resource_group_name = var.rg-name-hub1
}

resource "azurerm_firewall_policy_rule_collection_group" "fw-rulecollection" {
  name               = "fw-rulecollectiongroup1"
  firewall_policy_id = azurerm_firewall_policy.fw-policy.id
  priority           = 500
  depends_on         = [azurerm_firewall.fw]
  
  application_rule_collection {
    name     = "app_rule_collection1"
    priority = 500
    action   = "Allow"
    rule {
      name = "app_rule_collection1_rule1"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["*"]
      destination_fqdns = ["*"]
    }
  }

  network_rule_collection {
    name     = "network_rule_collection1"
    priority = 400
    action   = "Allow"
    rule {
      name                  = "network_rule_collection1_rule1"
      protocols             = ["TCP", "UDP"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }
  }

  nat_rule_collection {
    name     = "nat_rule_collection1"
    priority = 300
    action   = "Dnat"
    rule {
      name                = "nat_rule_collection1_rule1"
      protocols           = ["TCP", "UDP"]
      source_addresses    = ["*"]
      destination_address = var.pip-fw.ip_address
      destination_ports   = ["100"]
      translated_address  = "11.0.0.4"
      translated_port     = "3389"
    }

    rule {
      name                = "nat_rule_collection1_rule2"
      protocols           = ["TCP", "UDP"]
      source_addresses    = ["*"]
      destination_address = var.pip-fw.ip_address
      destination_ports   = ["200"]
      translated_address  = "21.0.1.4"
      translated_port     = "3389"
    }

    rule {
      name                = "nat_rule_collection1_rule3"
      protocols           = ["TCP", "UDP"]
      source_addresses    = ["*"]
      destination_address = var.pip-fw.ip_address
      destination_ports   = ["300"]
      translated_address  = "31.0.1.4"
      translated_port     = "3389"
    }

    rule {
      name                = "nat_rule_collection1_rule4"
      protocols           = ["TCP", "UDP"]
      source_addresses    = ["*"]
      destination_address = var.pip-fw.ip_address
      destination_ports   = ["400"]
      translated_address  = "11.0.0.4"
      translated_port     = "80"
    }

    rule {
      name                = "nat_rule_collection1_rule5"
      protocols           = ["TCP", "UDP"]
      source_addresses    = ["*"]
      destination_address = var.pip-fw.ip_address
      destination_ports   = ["8080"]
      translated_address  = "21.0.1.4"
      translated_port     = "80"
    }

    rule {
      name                = "nat_rule_collection1_rule6"
      protocols           = ["TCP", "UDP"]
      source_addresses    = ["*"]
      destination_address = var.pip-fw.ip_address
      destination_ports   = ["80"]
      translated_address  = "31.0.1.4"
      translated_port     = "80"
    }
  }
}

resource "azurerm_firewall" "fw" {
  name                = "fw-01"
  location            = var.rg-location
  resource_group_name = var.rg-name-hub1
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.fw-policy.id
  sku_name            = "AZFW_VNet"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.snet-fw.id
    public_ip_address_id = azurerm_public_ip.pip-fw.id
  }
}

data "azurerm_firewall" "fw-data" {
  name = azurerm_firewall.fw.name
  resource_group_name = var.rg-name-hub1
}

data "azurerm_public_ip" "pip-fw" {
  name = azurerm_public_ip.pip-fw.name
  resource_group_name = var.rg-name-hub1
}