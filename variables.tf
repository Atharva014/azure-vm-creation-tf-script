 variable "resource_group_name" {
  type = string
  default = "example-RG"
}

variable "location" {
  type = string
}

variable "vnet_cidr_block" {
  type = list(string)
}

variable "subnet_cidr_block" {
  type = list(string)
}

variable "vm_size" {
  type = string
  default = "Standard_D2als_v6"
}

variable "admin_username" {
  type = string
  default = "azureuser"
}

variable "admin_password" {
  type = string
  sensitive = true
}

variable "image_publisher" {
  type = string
  default = "Canonical"
}

variable "image_offer" {
  type = string
  default = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  type = string
  default = "22_04-lts-gen2"
}

variable "image_version" {
  type = string
  default = "latest"
}