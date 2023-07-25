<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_container_registry_id"></a> [container\_registry\_id](#input\_container\_registry\_id) | (Optional) The id of the azure container registry to assign access to the cluster. | `string` | `null` | no |
| <a name="input_diagnostics_name"></a> [diagnostics\_name](#input\_diagnostics\_name) | (Optional) The name of the diagnostic setting of the kubernetes cluster. | `string` | `"aks-diagnostics"` | no |
| <a name="input_dns_prefix"></a> [dns\_prefix](#input\_dns\_prefix) | (Optional) The dns prefix for the kuberenetes api. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location of the kubernetes cluster. | `string` | n/a | yes |
| <a name="input_log_analytics_id"></a> [log\_analytics\_id](#input\_log\_analytics\_id) | (Optional) The id of the log analytics workspace. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the kubernetes cluster. | `string` | n/a | yes |
| <a name="input_network_plugin"></a> [network\_plugin](#input\_network\_plugin) | (Optional) The network plugin of the aks, azure, kubenet or none. | `string` | `"none"` | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | (Required) A list of node pools, there must be exactly one node pool where the default property is true. | <pre>list(object({<br>    name                  = string<br>    node_count            = number<br>    vm_size               = string<br>    vnet_subnet_id        = string<br>    enable_auto_scaling   = optional(bool, false)<br>    default               = optional(bool, false)<br>    enable_node_public_ip = optional(bool, false)<br>    max_pods              = optional(number, null)<br>    min_count             = optional(number, null)<br>    max_count             = optional(number, null)<br>    os_sku                = optional(string, "Ubuntu")<br>    os_type               = optional(string, "Linux")<br>  }))</pre> | n/a | yes |
| <a name="input_node_resource_group"></a> [node\_resource\_group](#input\_node\_resource\_group) | (Required) The resource group name where all the components of the kubernetes cluster reside. | `string` | n/a | yes |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | (Optional) Should the kubernetes api get a private ip address on the virtual network. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The resource group name of the kubernetes cluster. | `string` | n/a | yes |

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
| <a name="module_aks-diagnostics"></a> [aks-diagnostics](#module\_aks-diagnostics) | github.com/danielkhen/diagnostic_setting_module | n/a |
<!-- END_TF_DOCS -->