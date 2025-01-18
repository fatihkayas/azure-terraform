variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "vm-video"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "West Europe"
}

variable "vnet_name" {
  description = "Virtual Network Name"
  type        = string
  default     = "example-network"
}

variable "subnet_name" {
  description = "Subnet Name"
  type        = string
  default     = "internal"
}

variable "address_space" {
  description = "VNet Address Space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_prefix" {
  description = "Subnet Address Prefix"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "vm_size" {
  description = "Azure VM Size"
  type        = string
  default     = "Standard_F2"
}

variable "admin_user" {
  description = "Admin Username"
  type        = string
  default     = "adminuser"
}

variable "ssh_key_path" {
  description = "Path to the SSH Public Key"
  type        = string
  default     = "sky2.pem"
}
