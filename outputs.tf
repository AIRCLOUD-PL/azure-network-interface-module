output "id" {
  description = "ID of the network interface"
  value       = azurerm_network_interface.main.id
}

output "name" {
  description = "Name of the network interface"
  value       = azurerm_network_interface.main.name
}

output "private_ip_address" {
  description = "Primary private IP address"
  value       = azurerm_network_interface.main.private_ip_address
}

output "private_ip_addresses" {
  description = "List of all private IP addresses"
  value       = azurerm_network_interface.main.private_ip_addresses
}

output "mac_address" {
  description = "MAC address of the network interface"
  value       = azurerm_network_interface.main.mac_address
}

output "internal_domain_name_suffix" {
  description = "Internal domain name suffix"
  value       = azurerm_network_interface.main.internal_domain_name_suffix
}

output "applied_dns_servers" {
  description = "Applied DNS servers"
  value       = azurerm_network_interface.main.applied_dns_servers
}
