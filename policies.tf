# Azure Policy Definitions for Network Interface
# This file contains Azure Policy definitions to enforce security and compliance for Network Interfaces

# Custom Policy Definition for Network Interface Security
resource "azurerm_policy_definition" "network_interface_accelerated_networking" {
  count = var.create_custom_policies ? 1 : 0

  name         = "${local.nic_name}-accelerated-networking-policy"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Network Interfaces should have accelerated networking enabled"

  policy_rule = jsonencode({
    if = {
      field  = "type"
      equals = "Microsoft.Network/networkInterfaces"
    }
    then = {
      effect = "Audit"
      details = {
        type = "Microsoft.Network/networkInterfaces"
        existenceCondition = {
          field  = "Microsoft.Network/networkInterfaces/enableAcceleratedNetworking"
          equals = true
        }
      }
    }
  })

  metadata = jsonencode({
    category = "Network"
  })
}

# Custom Policy Definition for Network Interface IP Forwarding
resource "azurerm_policy_definition" "network_interface_ip_forwarding" {
  count = var.create_custom_policies ? 1 : 0

  name         = "${local.nic_name}-ip-forwarding-policy"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Network Interfaces should not have IP forwarding enabled unless required"

  policy_rule = jsonencode({
    if = {
      field  = "type"
      equals = "Microsoft.Network/networkInterfaces"
    }
    then = {
      effect = "Audit"
      details = {
        type = "Microsoft.Network/networkInterfaces"
        existenceCondition = {
          field  = "Microsoft.Network/networkInterfaces/enableIPForwarding"
          equals = false
        }
      }
    }
  })

  metadata = jsonencode({
    category = "Network"
  })
}

# Custom Policy Definition for Network Interface NSG Association
resource "azurerm_policy_definition" "network_interface_nsg_association" {
  count = var.create_custom_policies ? 1 : 0

  name         = "${local.nic_name}-nsg-association-policy"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Network Interfaces should be associated with a Network Security Group"

  policy_rule = jsonencode({
    if = {
      field  = "type"
      equals = "Microsoft.Network/networkInterfaces"
    }
    then = {
      effect = "AuditIfNotExists"
      details = {
        type = "Microsoft.Network/networkInterfaces"
        existenceCondition = {
          field  = "Microsoft.Network/networkInterfaces/networkSecurityGroup.id"
          exists = true
        }
      }
    }
  })

  metadata = jsonencode({
    category = "Network"
  })
}

# Custom Policy Definition for Network Interface Public IP
resource "azurerm_policy_definition" "network_interface_public_ip" {
  count = var.create_custom_policies ? 1 : 0

  name         = "${local.nic_name}-public-ip-policy"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Network Interfaces should not have public IP addresses unless required"

  policy_rule = jsonencode({
    if = {
      field  = "type"
      equals = "Microsoft.Network/networkInterfaces"
    }
    then = {
      effect = "Audit"
      details = {
        type = "Microsoft.Network/networkInterfaces"
        existenceCondition = {
          field  = "Microsoft.Network/networkInterfaces/ipConfigurations[*].publicIPAddress.id"
          exists = false
        }
      }
    }
  })

  metadata = jsonencode({
    category = "Network"
  })
}