# Azure Network Interface Terraform Module

Standalone Azure Network Interface module for flexible network configuration.

## Features

✅ **Multiple IP Configurations** - Support for primary and secondary IPs  
✅ **Security Group Integration** - NSG and ASG associations  
✅ **Load Balancer Support** - Backend pool and NAT rule associations  
✅ **Accelerated Networking** - Enhanced network performance  
✅ **DNS Configuration** - Custom DNS servers and internal DNS labels  
✅ **IP Forwarding** - Support for network virtual appliances  

## Usage

### Basic Example

```hcl
module "network_interface" {
  source = "github.com/your-org/terraform-azurerm-network-interface?ref=v1.0.0"

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
  source = "github.com/your-org/terraform-azurerm-network-interface?ref=v1.0.0"

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
source = "github.com/your-org/terraform-azurerm-network-interface?ref=v1.0.0"
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| azurerm | >= 3.80.0 |

## Inputs

See [variables.tf](./variables.tf) for all available inputs.

## Outputs

See [outputs.tf](./outputs.tf) for all available outputs.

## License

MIT

## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
