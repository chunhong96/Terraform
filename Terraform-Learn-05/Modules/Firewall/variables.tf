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

variable "rg_name_hub" {
    type = object({
        name = string
        location = string
    })
    default = {
        name = " "
        location = " "
    }
}

variable "vnet-hub" {
    default = {
        id = " "
        name = " "
    }
}

variable "vm-hub" {
    default = {
        id = " "
        name = " "
        ip_address = " "
    }
}