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