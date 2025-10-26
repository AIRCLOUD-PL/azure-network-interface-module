package test

import (
	"testing"
	"fmt"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestNetworkInterfaceBasic(t *testing.T) {
	t.Parallel()

	// Generate unique names
	uniqueId := random.UniqueId()
	location := "East US"
	resourceGroupName := fmt.Sprintf("rg-nic-test-%s", uniqueId)
	vnetName := fmt.Sprintf("vnet-nic-test-%s", uniqueId)
	subnetName := fmt.Sprintf("subnet-nic-test-%s", uniqueId)
	nicName := fmt.Sprintf("nic-test-%s", uniqueId)

	terraformOptions := &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"name":                nicName,
			"resource_group_name": resourceGroupName,
			"location":            location,
			"environment":         "test",
			"primary_ip_configuration": map[string]interface{}{
				"name":                          "primary",
				"subnet_id":                     "subnet-id-placeholder", // Would need actual subnet
				"private_ip_address_allocation": "Dynamic",
			},
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Verify Network Interface exists
	nicExists := azure.NetworkInterfaceExists(t, nicName, resourceGroupName, "")
	require.True(t, nicExists, "Network Interface should exist")

	// Verify NIC properties
	nic := azure.GetNetworkInterface(t, nicName, resourceGroupName, "")
	assert.Equal(t, nicName, nic.Name)
	assert.False(t, nic.EnableIPForwarding)
	assert.False(t, nic.EnableAcceleratedNetworking)
}

func TestNetworkInterfaceWithAcceleratedNetworking(t *testing.T) {
	t.Parallel()

	// Generate unique names
	uniqueId := random.UniqueId()
	location := "East US"
	resourceGroupName := fmt.Sprintf("rg-nic-an-%s", uniqueId)
	nicName := fmt.Sprintf("nic-an-%s", uniqueId)

	terraformOptions := &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"name":                       nicName,
			"resource_group_name":        resourceGroupName,
			"location":                   location,
			"environment":                "test",
			"enable_accelerated_networking": true,
			"primary_ip_configuration": map[string]interface{}{
				"name":                          "primary",
				"subnet_id":                     "subnet-id-placeholder",
				"private_ip_address_allocation": "Dynamic",
			},
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Verify Network Interface exists
	nicExists := azure.NetworkInterfaceExists(t, nicName, resourceGroupName, "")
	require.True(t, nicExists, "Network Interface should exist")

	// Verify accelerated networking is enabled
	nic := azure.GetNetworkInterface(t, nicName, resourceGroupName, "")
	assert.True(t, nic.EnableAcceleratedNetworking)
}

func TestNetworkInterfaceWithIPForwarding(t *testing.T) {
	t.Parallel()

	// Generate unique names
	uniqueId := random.UniqueId()
	location := "East US"
	resourceGroupName := fmt.Sprintf("rg-nic-ipf-%s", uniqueId)
	nicName := fmt.Sprintf("nic-ipf-%s", uniqueId)

	terraformOptions := &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"name":                nicName,
			"resource_group_name": resourceGroupName,
			"location":            location,
			"environment":         "test",
			"enable_ip_forwarding": true,
			"primary_ip_configuration": map[string]interface{}{
				"name":                          "primary",
				"subnet_id":                     "subnet-id-placeholder",
				"private_ip_address_allocation": "Dynamic",
			},
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Verify Network Interface exists
	nicExists := azure.NetworkInterfaceExists(t, nicName, resourceGroupName, "")
	require.True(t, nicExists, "Network Interface should exist")

	// Verify IP forwarding is enabled
	nic := azure.GetNetworkInterface(t, nicName, resourceGroupName, "")
	assert.True(t, nic.EnableIPForwarding)
}

func TestNetworkInterfaceWithStaticIP(t *testing.T) {
	t.Parallel()

	// Generate unique names
	uniqueId := random.UniqueId()
	location := "East US"
	resourceGroupName := fmt.Sprintf("rg-nic-static-%s", uniqueId)
	nicName := fmt.Sprintf("nic-static-%s", uniqueId)
	staticIP := "10.0.1.100"

	terraformOptions := &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"name":                nicName,
			"resource_group_name": resourceGroupName,
			"location":            location,
			"environment":         "test",
			"primary_ip_configuration": map[string]interface{}{
				"name":                          "primary",
				"subnet_id":                     "subnet-id-placeholder",
				"private_ip_address_allocation": "Static",
				"private_ip_address":            staticIP,
			},
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Verify Network Interface exists
	nicExists := azure.NetworkInterfaceExists(t, nicName, resourceGroupName, "")
	require.True(t, nicExists, "Network Interface should exist")

	// Verify static IP is assigned
	nic := azure.GetNetworkInterface(t, nicName, resourceGroupName, "")
	assert.Contains(t, nic.IPConfigurations, staticIP)
}

func TestNetworkInterfaceWithDNS(t *testing.T) {
	t.Parallel()

	// Generate unique names
	uniqueId := random.UniqueId()
	location := "East US"
	resourceGroupName := fmt.Sprintf("rg-nic-dns-%s", uniqueId)
	nicName := fmt.Sprintf("nic-dns-%s", uniqueId)

	terraformOptions := &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"name":                nicName,
			"resource_group_name": resourceGroupName,
			"location":            location,
			"environment":         "test",
			"dns_servers":         []string{"8.8.8.8", "8.8.4.4"},
			"primary_ip_configuration": map[string]interface{}{
				"name":                          "primary",
				"subnet_id":                     "subnet-id-placeholder",
				"private_ip_address_allocation": "Dynamic",
			},
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Verify Network Interface exists
	nicExists := azure.NetworkInterfaceExists(t, nicName, resourceGroupName, "")
	require.True(t, nicExists, "Network Interface should exist")

	// Verify DNS servers are configured
	nic := azure.GetNetworkInterface(t, nicName, resourceGroupName, "")
	assert.Equal(t, []string{"8.8.8.8", "8.8.4.4"}, nic.DNSServers)
}

func TestNetworkInterfaceInputValidation(t *testing.T) {
	t.Parallel()

	// Test invalid IP allocation method
	terraformOptions := &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"name":                "test-invalid-ip-allocation",
			"resource_group_name": "rg-test",
			"location":            "East US",
			"environment":         "test",
			"primary_ip_configuration": map[string]interface{}{
				"name":                          "primary",
				"subnet_id":                     "subnet-id",
				"private_ip_address_allocation": "Invalid",
			},
		},
		ExpectFailure: true,
	}

	terraform.Init(t, terraformOptions)
	_, err := terraform.PlanE(t, terraformOptions)
	require.Error(t, err, "Should fail with invalid IP allocation method")
	assert.Contains(t, err.Error(), "private_ip_address_allocation", "Error should mention IP allocation validation")
}