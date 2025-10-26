/**
 * # Azure Network Interface Module
 *
 * Enterprise-grade Azure Network Interface module with security and monitoring features.
 * This module can be used standalone or as part of VM deployments.
 *
 * ## Features
 * - Multiple IP configurations support
 * - Application Security Group association
 * - Network Security Group association
 * - Accelerated networking
 * - IP forwarding
 * - Static and dynamic IP allocation
 * - DNS configuration
 * - Public IP association
 */

locals {
  # Auto-generate name if not provided
  nic_name = var.name != null ? var.name : "${var.naming_prefix}-${var.environment}-${var.location}-nic-${var.instance_number}"

  # Default tags
  default_tags = {
    ManagedBy   = "Terraform"
    Module      = "azure-network-interface"
    Environment = var.environment
  }

  tags = merge(local.default_tags, var.tags)
}

# Network Interface
resource "azurerm_network_interface" "main" {
  name                = local.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  # Primary IP Configuration (required)
  ip_configuration {
    name                          = var.primary_ip_configuration.name
    subnet_id                     = var.primary_ip_configuration.subnet_id
    private_ip_address_allocation = var.primary_ip_configuration.private_ip_address_allocation
    private_ip_address            = var.primary_ip_configuration.private_ip_address_allocation == "Static" ? var.primary_ip_configuration.private_ip_address : null
    public_ip_address_id          = var.primary_ip_configuration.public_ip_address_id
    primary                       = true
  }

  # Additional IP Configurations
  dynamic "ip_configuration" {
    for_each = var.additional_ip_configurations
    content {
      name                          = ip_configuration.value.name
      subnet_id                     = ip_configuration.value.subnet_id
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
      private_ip_address            = ip_configuration.value.private_ip_address_allocation == "Static" ? ip_configuration.value.private_ip_address : null
      public_ip_address_id          = ip_configuration.value.public_ip_address_id
      primary                       = false
    }
  }

  dns_servers                    = var.dns_servers
  ip_forwarding_enabled          = var.enable_ip_forwarding
  accelerated_networking_enabled = var.enable_accelerated_networking
  internal_dns_name_label        = var.internal_dns_name_label

  tags = local.tags
}

# Application Security Group Association
resource "azurerm_network_interface_application_security_group_association" "main" {
  for_each = toset(var.application_security_group_ids)

  network_interface_id          = azurerm_network_interface.main.id
  application_security_group_id = each.value
}

# Network Security Group Association
resource "azurerm_network_interface_security_group_association" "main" {
  count = var.network_security_group_id != null ? 1 : 0

  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = var.network_security_group_id
}

# Backend Address Pool Association (for Load Balancer)
resource "azurerm_network_interface_backend_address_pool_association" "main" {
  for_each = toset(var.backend_address_pool_ids)

  network_interface_id    = azurerm_network_interface.main.id
  ip_configuration_name   = var.primary_ip_configuration.name
  backend_address_pool_id = each.value
}

# NAT Rule Association (for Load Balancer)
resource "azurerm_network_interface_nat_rule_association" "main" {
  for_each = toset(var.nat_rule_ids)

  network_interface_id  = azurerm_network_interface.main.id
  ip_configuration_name = var.primary_ip_configuration.name
  nat_rule_id           = each.value
}
