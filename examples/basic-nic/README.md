# Basic Network Interface Example

This example demonstrates how to create a basic Azure Network Interface with essential networking features.

## Overview

This example creates:
- A resource group
- A virtual network with a subnet
- A network security group with SSH access
- An Azure Network Interface with dynamic IP allocation
- DNS server configuration
- NSG association

## Architecture

```
Virtual Network
    └── Subnet (10.0.1.0/24)
        └── Network Interface
            ├── Dynamic Private IP
            ├── Custom DNS Servers
            └── NSG Association
```

## Usage

1. Navigate to this directory:
   ```bash
   cd examples/basic-nic
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review the plan:
   ```bash
   terraform plan
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

5. Clean up when done:
   ```bash
   terraform destroy
   ```

## Configuration

The network interface is configured with:
- **IP Allocation**: Dynamic private IP address
- **DNS Servers**: Google DNS (8.8.8.8, 8.8.4.4)
- **Security**: Associated with NSG allowing SSH
- **Features**: Standard networking (no acceleration or IP forwarding)

## Security Features

- Network Security Group association for traffic filtering
- Custom DNS configuration for name resolution
- Resource tagging for governance

## Outputs

- `network_interface_id`: The resource ID of the Network Interface
- `network_interface_name`: The name of the Network Interface
- `private_ip_address`: Private IP address assigned to the NIC
- `mac_address`: MAC address of the Network Interface

## Next Steps

- Explore additional [examples](../) for advanced configurations
- Review the main module [README](../../README.md) for all available options
- Consider using this NIC with a Virtual Machine module