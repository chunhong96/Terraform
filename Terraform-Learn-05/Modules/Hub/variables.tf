variable "rg_name" {
    type = object({
        name = string
        location = string
    })
    default = {
        name = " "
        location = " "
    }
}

variable "vnet-spoke" {
    default = {
        id = " "
    }
}

variable "active_directory_domain" {
    default = {
        name = " "
    }
}
variable "active_directory_netbios_name" {
    default = {
        name = " "
    }
}
variable "admin_password" {
    default = {
        name = " "
    }
}

variable "virtual_machine_id" {
    default = {
        id = " "
    }
}