# Basic Network Interface Example
# This example demonstrates how to create a basic Azure Network Interface

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "example" {
  name     = "rg-nic-example"
  location = "East US 2"

  tags = {
    Environment = "example"
    Module      = "azure-network-interface"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "example" {
  name                = "vnet-nic-example"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  tags = {
    Environment = "example"
    Module      = "azure-network-interface"
  }
}

# Subnet
resource "azurerm_subnet" "example" {
  name                 = "subnet-nic-example"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "example" {
  name                = "nsg-nic-example"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = "example"
    Module      = "azure-network-interface"
  }
}

# Azure Network Interface Module
module "network_interface" {
  source = "../../"

  name                = "nic-example-001"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  environment         = "example"

  # Primary IP Configuration
  primary_ip_configuration = {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }

  # DNS Configuration
  dns_servers = ["8.8.8.8", "8.8.4.4"]

  # Security Group Association
  network_security_group_id = azurerm_network_security_group.example.id

  # Network Features
  enable_accelerated_networking = false
  enable_ip_forwarding          = false

  tags = {
    Environment = "example"
    Purpose     = "basic-network-interface-demo"
  }
}

# Outputs
output "network_interface_id" {
  description = "The ID of the Network Interface"
  value       = module.network_interface.id
}

output "network_interface_name" {
  description = "The name of the Network Interface"
  value       = module.network_interface.name
}

output "private_ip_address" {
  description = "The private IP address of the Network Interface"
  value       = module.network_interface.private_ip_address
}

output "mac_address" {
  description = "The MAC address of the Network Interface"
  value       = module.network_interface.mac_address
}