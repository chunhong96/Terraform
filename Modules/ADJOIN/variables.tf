variable "vm-spoke1" {
}

variable "vm-spoke2" {
}

variable "active_directory_domain" {
  description = "The name of the Active Directory domain, for example `consoto.local`"
}

variable "active_directory_username" {
  description = "The username of an account with permissions to bind machines to the Active Directory Domain"
}

variable "active_directory_password" {
  description = "The password of the account with permissions to bind machines to the Active Directory Domain"
}

