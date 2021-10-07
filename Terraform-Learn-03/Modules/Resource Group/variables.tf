variable "rg-hub" {
    type = object({
        name = string
        location = string
    })
    default = {
        name = "rg-hub"
        location = "southeastasia"
    }
}

variable "rg-spoke" {
    type = object({
        name = string
        location = string
    })
    default = {
        name = "rg-spoke"
        location = "southeastasia"
    }
}