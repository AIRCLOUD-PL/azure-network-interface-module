<p align="center">
  <a href="https://aircloud.com.pl"><img src=".github/assets/banner.png" alt="AIRCLOUD: DevOps, cloud and AI engineering" width="100%"></a>
</p>

# azure-network-interface-module

**Azure Network Interface Terraform module — parameterised, azurerm 4.x, CI-validated.**

[![CI](https://github.com/AIRCLOUD-PL/azure-network-interface-module/actions/workflows/ci.yml/badge.svg)](https://github.com/AIRCLOUD-PL/azure-network-interface-module/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Release](https://img.shields.io/github/v/release/AIRCLOUD-PL/azure-network-interface-module?sort=semver)](https://github.com/AIRCLOUD-PL/azure-network-interface-module/releases)

Standalone Azure Network Interface module for flexible network configuration.

## Features

✅ **Multiple IP Configurations** - Support for primary and secondary IPs  
✅ **Security Group Integration** - NSG and ASG associations  
✅ **Load Balancer Support** - Backend pool and NAT rule associations  
✅ **Accelerated Networking** - Enhanced network performance  
✅ **DNS Configuration** - Custom DNS servers and internal DNS labels  
✅ **IP Forwarding** - Support for network virtual appliances  

## Usage

Pin the module to a release tag:

```hcl
module "network_interface" {
  source = "git::https://github.com/AIRCLOUD-PL/azure-network-interface-module.git?ref=v1.0.0"

  # required inputs
  environment              = "..."
  location                 = "..."
  primary_ip_configuration = {}
  resource_group_name      = "..."
}
```

All inputs and outputs are listed in the generated reference below ([Inputs](#inputs), [Outputs](#outputs)). Worked examples live in [`examples/`](examples/).

### Basic Example

```hcl
module "network_interface" {
  source = "git::https://github.com/AIRCLOUD-PL/azure-network-interface-module.git?ref=v1.0.0"

  name                = "nic-prod-westeu-001"
  location            = "westeurope"
  resource_group_name = "rg-production"
  environment         = "prod"
  
  primary_ip_configuration = {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
  
  tags = {
    Environment = "Production"
  }
}
```

### With Static IP and NSG

```hcl
module "network_interface" {
  source = "git::https://github.com/AIRCLOUD-PL/azure-network-interface-module.git?ref=v1.0.0"

  name                = "nic-prod-westeu-001"
  location            = "westeurope"
  resource_group_name = "rg-production"
  environment         = "prod"
  
  primary_ip_configuration = {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.10"
  }
  
  network_security_group_id = azurerm_network_security_group.main.id
  enable_accelerated_networking = true
  
  tags = {
    Environment = "Production"
  }
}
```

## Version

Current version: **v1.0.0**

Always specify a version when using this module:
```hcl
source = "git::https://github.com/AIRCLOUD-PL/azure-network-interface-module.git?ref=v1.0.0"
```

## License

MIT

## Reference

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.81.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_interface.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_application_security_group_association.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_security_group_association) | resource |
| [azurerm_network_interface_backend_address_pool_association.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_interface_nat_rule_association.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_nat_rule_association) | resource |
| [azurerm_network_interface_security_group_association.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_policy_definition.network_interface_accelerated_networking](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.network_interface_ip_forwarding](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.network_interface_nsg_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_policy_definition.network_interface_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_ip_configurations"></a> [additional\_ip\_configurations](#input\_additional\_ip\_configurations) | List of additional IP configurations | <pre>list(object({<br/>    name                          = string<br/>    subnet_id                     = string<br/>    private_ip_address_allocation = string<br/>    private_ip_address            = optional(string)<br/>    public_ip_address_id          = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_application_security_group_ids"></a> [application\_security\_group\_ids](#input\_application\_security\_group\_ids) | List of Application Security Group IDs to associate with the NIC | `list(string)` | `[]` | no |
| <a name="input_backend_address_pool_ids"></a> [backend\_address\_pool\_ids](#input\_backend\_address\_pool\_ids) | List of Backend Address Pool IDs for Load Balancer integration | `list(string)` | `[]` | no |
| <a name="input_create_custom_policies"></a> [create\_custom\_policies](#input\_create\_custom\_policies) | Create custom Azure Policy definitions for network interfaces | `bool` | `false` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | List of DNS server IP addresses | `list(string)` | `[]` | no |
| <a name="input_enable_accelerated_networking"></a> [enable\_accelerated\_networking](#input\_enable\_accelerated\_networking) | Enable accelerated networking (requires supported VM size) | `bool` | `false` | no |
| <a name="input_enable_ip_forwarding"></a> [enable\_ip\_forwarding](#input\_enable\_ip\_forwarding) | Enable IP forwarding on the network interface | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g., prod, dev, test) | `string` | n/a | yes |
| <a name="input_instance_number"></a> [instance\_number](#input\_instance\_number) | Instance number for the NIC (used in auto-generated names) | `string` | `"001"` | no |
| <a name="input_internal_dns_name_label"></a> [internal\_dns\_name\_label](#input\_internal\_dns\_name\_label) | Internal DNS name label for the network interface | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region where the network interface will be created | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the network interface. If null, will be auto-generated. | `string` | `null` | no |
| <a name="input_naming_prefix"></a> [naming\_prefix](#input\_naming\_prefix) | Prefix for resource naming when auto-generating names | `string` | `"nic"` | no |
| <a name="input_nat_rule_ids"></a> [nat\_rule\_ids](#input\_nat\_rule\_ids) | List of NAT Rule IDs for Load Balancer integration | `list(string)` | `[]` | no |
| <a name="input_network_security_group_id"></a> [network\_security\_group\_id](#input\_network\_security\_group\_id) | ID of Network Security Group to associate with the NIC | `string` | `null` | no |
| <a name="input_primary_ip_configuration"></a> [primary\_ip\_configuration](#input\_primary\_ip\_configuration) | Primary IP configuration for the network interface | <pre>object({<br/>    name                          = string<br/>    subnet_id                     = string<br/>    private_ip_address_allocation = string<br/>    private_ip_address            = optional(string)<br/>    public_ip_address_id          = optional(string)<br/>  })</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the network interface | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_applied_dns_servers"></a> [applied\_dns\_servers](#output\_applied\_dns\_servers) | Applied DNS servers |
| <a name="output_id"></a> [id](#output\_id) | ID of the network interface |
| <a name="output_internal_domain_name_suffix"></a> [internal\_domain\_name\_suffix](#output\_internal\_domain\_name\_suffix) | Internal domain name suffix |
| <a name="output_mac_address"></a> [mac\_address](#output\_mac\_address) | MAC address of the network interface |
| <a name="output_name"></a> [name](#output\_name) | Name of the network interface |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | Primary private IP address |
| <a name="output_private_ip_addresses"></a> [private\_ip\_addresses](#output\_private\_ip\_addresses) | List of all private IP addresses |
<!-- END_TF_DOCS -->

---

## Part of the AIRCLOUD Azure module catalog

Browse all modules with usage snippets in the [module catalog](https://aircloud-pl.github.io/) or on [github.com/AIRCLOUD-PL](https://github.com/AIRCLOUD-PL). Built and maintained by [AIRCLOUD](https://aircloud.com.pl): DevOps, cloud and AI engineering. Need a hand with Azure landing zones or platform engineering? See [aircloud.com.pl/consulting](https://aircloud.com.pl/consulting).
