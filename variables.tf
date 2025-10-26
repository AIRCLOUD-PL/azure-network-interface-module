variable "name" {
  description = "Name of the network interface. If null, will be auto-generated."
  type        = string
  default     = null
}

variable "naming_prefix" {
  description = "Prefix for resource naming when auto-generating names"
  type        = string
  default     = "nic"
}

variable "environment" {
  description = "Environment name (e.g., prod, dev, test)"
  type        = string
}

variable "instance_number" {
  description = "Instance number for the NIC (used in auto-generated names)"
  type        = string
  default     = "001"
}

variable "location" {
  description = "Azure region where the network interface will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

# Primary IP Configuration
variable "primary_ip_configuration" {
  description = "Primary IP configuration for the network interface"
  type = object({
    name                          = string
    subnet_id                     = string
    private_ip_address_allocation = string
    private_ip_address            = optional(string)
    public_ip_address_id          = optional(string)
  })

  validation {
    condition     = contains(["Dynamic", "Static"], var.primary_ip_configuration.private_ip_address_allocation)
    error_message = "private_ip_address_allocation must be either 'Dynamic' or 'Static'."
  }
}

# Additional IP Configurations
variable "additional_ip_configurations" {
  description = "List of additional IP configurations"
  type = list(object({
    name                          = string
    subnet_id                     = string
    private_ip_address_allocation = string
    private_ip_address            = optional(string)
    public_ip_address_id          = optional(string)
  }))
  default = []
}

# DNS Configuration
variable "dns_servers" {
  description = "List of DNS server IP addresses"
  type        = list(string)
  default     = []
}

variable "internal_dns_name_label" {
  description = "Internal DNS name label for the network interface"
  type        = string
  default     = null
}

# Network Features
variable "enable_ip_forwarding" {
  description = "Enable IP forwarding on the network interface"
  type        = bool
  default     = false
}

variable "enable_accelerated_networking" {
  description = "Enable accelerated networking (requires supported VM size)"
  type        = bool
  default     = false
}

# Security Groups
variable "network_security_group_id" {
  description = "ID of Network Security Group to associate with the NIC"
  type        = string
  default     = null
}

variable "application_security_group_ids" {
  description = "List of Application Security Group IDs to associate with the NIC"
  type        = list(string)
  default     = []
}

# Load Balancer Integration
variable "backend_address_pool_ids" {
  description = "List of Backend Address Pool IDs for Load Balancer integration"
  type        = list(string)
  default     = []
}

variable "nat_rule_ids" {
  description = "List of NAT Rule IDs for Load Balancer integration"
  type        = list(string)
  default     = []
}

# Tags
variable "tags" {
  description = "Tags to apply to the network interface"
  type        = map(string)
  default     = {}
}

variable "create_custom_policies" {
  description = "Create custom Azure Policy definitions for network interfaces"
  type        = bool
  default     = false
}
