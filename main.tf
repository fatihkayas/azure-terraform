terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.27.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet
resource "azurerm_subnet" "example" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_prefix
}

# Network Interface
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                                     = "internal"
    subnet_id                                = azurerm_subnet.example.id
    private_ip_address_allocation            = "Dynamic"
    public_ip_address_id                     = azurerm_public_ip.example.id
  }
}

# Availability Set
resource "azurerm_availability_set" "example" {
  name                         = "example-aset"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.rg.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5

  tags = {
    environment = "Production"
  }
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "example" {
  name                  = "example-machine"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = var.location
  size                  = var.vm_size
  admin_username        = var.admin_user
  network_interface_ids = [azurerm_network_interface.example.id]
  availability_set_id   = azurerm_availability_set.example.id

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = var.admin_user
    public_key = file(var.ssh_key_path)

  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

output "vm_public_ip" {
  value = azurerm_public_ip.example.ip_address
}


resource azurerm_public_ip "example" {
  name                = "example-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  allocation_method = "Dynamic"
}