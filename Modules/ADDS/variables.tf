variable "vm-hub1" {
}

# Active Directory & Domain Controller
variable vmname {
  description = "The Virtual Machine name that you wish to join to the domain"
}

variable "active_directory_domain" {
  description = "The name of the Active Directory domain, for example `consoto.local`"
}

variable "admin_password" {
  description = "The password associated with the local administrator account on the virtual machine"
}

variable "active_directory_netbios_name" {
  description = "The netbios name of the Active Directory domain, for example `consoto`"
}

variable "virtual_machine_id" {
  
}

variable "data-vnet-hub1" {
}

variable "data-vnet-spoke1" {
}

variable "data-vnet-spoke2" {
}

variable "data-nic-hub1" {
}


