<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_container_registry_id"></a> [container\_registry\_id](#input\_container\_registry\_id) | (Optional) The id of the azure container registry to assign access to the. | `string` | `null` | no |
| <a name="input_container_registry_role"></a> [container\_registry\_role](#input\_container\_registry\_role) | (Optional) Should there be a role assignment to a container registry. | `bool` | `false` | no |
| <a name="input_default_node_pool"></a> [default\_node\_pool](#input\_default\_node\_pool) | (Required) The default node pool of the kubernetes cluster. | <pre>object({<br>    name                  = string<br>    node_count            = number<br>    vm_size               = string<br>    vnet_subnet_id        = optional(string, null)<br>    enable_auto_scaling   = optional(bool, false)<br>    enable_node_public_ip = optional(bool, false)<br>    max_pods              = optional(number, null)<br>    min_count             = optional(number, null)<br>    max_count             = optional(number, null)<br>    os_sku                = optional(string, "Ubuntu")<br>    os_type               = optional(string, "Linux")<br>  })</pre> | n/a | yes |
| <a name="input_diagnostics_name"></a> [diagnostics\_name](#input\_diagnostics\_name) | (Optional) The name of the diagnostic setting of the kubernetes cluster. | `string` | `"aks-diagnostics"` | no |
| <a name="input_dns_prefix"></a> [dns\_prefix](#input\_dns\_prefix) | (Optional) The dns prefix for the kuberenetes api. | `string` | `null` | no |
| <a name="input_dns_service_ip"></a> [dns\_service\_ip](#input\_dns\_service\_ip) | (Optional) The ip address of the dns service. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location of the kubernetes cluster. | `string` | n/a | yes |
| <a name="input_log_analytics_enabled"></a> [log\_analytics\_enabled](#input\_log\_analytics\_enabled) | (Optional) Should all logs be sent to a log analytics workspace. | `bool` | `false` | no |
| <a name="input_log_analytics_id"></a> [log\_analytics\_id](#input\_log\_analytics\_id) | (Optional) The id of the log analytics workspace. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the kubernetes cluster. | `string` | n/a | yes |
| <a name="input_network_plugin"></a> [network\_plugin](#input\_network\_plugin) | (Optional) The network plugin of the aks, azure, kubenet or none. | `string` | `"none"` | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | (Optional) A list of node pools. | <pre>list(object({<br>    name                  = string<br>    node_count            = number<br>    vm_size               = string<br>    vnet_subnet_id        = optional(string, null)<br>    enable_auto_scaling   = optional(bool, false)<br>    enable_node_public_ip = optional(bool, false)<br>    max_pods              = optional(number, null)<br>    min_count             = optional(number, null)<br>    max_count             = optional(number, null)<br>    os_sku                = optional(string, "Ubuntu")<br>    os_type               = optional(string, "Linux")<br>  }))</pre> | `[]` | no |
| <a name="input_node_resource_group"></a> [node\_resource\_group](#input\_node\_resource\_group) | (Optional) The resource group name where all the components of the kubernetes cluster reside. | `string` | `null` | no |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | (Optional) Should the kubernetes api get a private ip address on the virtual network. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The resource group name of the kubernetes cluster. | `string` | n/a | yes |
| <a name="input_service_cidr"></a> [service\_cidr](#input\_service\_cidr) | (Optional) The range of ip addresses assigned to services. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.node_pools](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_role_assignment.acr_role](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aks_diagnostics"></a> [aks\_diagnostics](#module\_aks\_diagnostics) | github.com/danielkhen/diagnostic_setting_module | n/a |

## Example Code

```hcl
module "aks" {
  source = "github.com/danielkhen/kubernetes_cluster_module"

  name                    = "example-aks"
  location                = "westeurope"
  resource_group_name     = azurerm_resource_group.example.name
  node_resource_group     = "example-aks-rg"
  dns_prefix              = "example-aks-dns"
  private_cluster_enabled = true
  network_plugin          = "kubenet"
  service_cidr            = "172.0.0.0/16"
  dns_service_ip          = "172.0.0.10"
  container_registry_id   = azurerm_container_registry.example.id

  # View variable documentation
  default_node_pool = local.default_node_pool
  node_pools        = local.node_pools

  log_analytics_enabled = true
  log_analytics_id      = azurerm_log_analytics_workspace.example.id
}
```
<!-- END_TF_DOCS -->