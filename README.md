<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.67.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aad_tenant_id"></a> [aad\_tenant\_id](#input\_aad\_tenant\_id) | (Required) The aad tenant id. | `string` | n/a | yes |
| <a name="input_vm_admin_password"></a> [vm\_admin\_password](#input\_vm\_admin\_password) | (Optional) The username for the admin user in the virtual machines. | `string` | `null` | no |

## Outputs

No outputs.

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.monitor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.work](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_hub_acr"></a> [hub\_acr](#module\_hub\_acr) | github.com/danielkhen/container_registry_module | n/a |
| <a name="module_hub_firewall"></a> [hub\_firewall](#module\_hub\_firewall) | github.com/danielkhen/firewall_module | n/a |
| <a name="module_hub_firewall_policy"></a> [hub\_firewall\_policy](#module\_hub\_firewall\_policy) | github.com/danielkhen/firewall_policy_module | n/a |
| <a name="module_hub_log_analytics"></a> [hub\_log\_analytics](#module\_hub\_log\_analytics) | github.com/danielkhen/log_analytics_workspace_module | n/a |
| <a name="module_hub_network_security_groups"></a> [hub\_network\_security\_groups](#module\_hub\_network\_security\_groups) | github.com/danielkhen/network_security_group_module | n/a |
| <a name="module_hub_route_tables"></a> [hub\_route\_tables](#module\_hub\_route\_tables) | github.com/danielkhen/route_table_module | n/a |
| <a name="module_hub_to_monitor_peerings"></a> [hub\_to\_monitor\_peerings](#module\_hub\_to\_monitor\_peerings) | ./modules/virtual_network_peerings | n/a |
| <a name="module_hub_to_work_peerings"></a> [hub\_to\_work\_peerings](#module\_hub\_to\_work\_peerings) | ./modules/virtual_network_peerings | n/a |
| <a name="module_hub_virtual_network"></a> [hub\_virtual\_network](#module\_hub\_virtual\_network) | github.com/danielkhen/virtual_network_module | n/a |
| <a name="module_hub_vpn_gateway"></a> [hub\_vpn\_gateway](#module\_hub\_vpn\_gateway) | github.com/danielkhen/virtual_network_gateway_module | n/a |
| <a name="module_ipam"></a> [ipam](#module\_ipam) | github.com/danielkhen/ip_address_management_module | n/a |
| <a name="module_monitor_network_security_groups"></a> [monitor\_network\_security\_groups](#module\_monitor\_network\_security\_groups) | github.com/danielkhen/network_security_group_module | n/a |
| <a name="module_monitor_route_tables"></a> [monitor\_route\_tables](#module\_monitor\_route\_tables) | github.com/danielkhen/route_table_module | n/a |
| <a name="module_monitor_virtual_network"></a> [monitor\_virtual\_network](#module\_monitor\_virtual\_network) | github.com/danielkhen/virtual_network_module | n/a |
| <a name="module_monitor_vm"></a> [monitor\_vm](#module\_monitor\_vm) | github.com/danielkhen/virtual_machine_module | n/a |
| <a name="module_monitor_vm_dns_zone"></a> [monitor\_vm\_dns\_zone](#module\_monitor\_vm\_dns\_zone) | github.com/danielkhen/private_dns_zone_module | n/a |
| <a name="module_work_aks"></a> [work\_aks](#module\_work\_aks) | github.com/danielkhen/kubernetes_cluster_module | n/a |
| <a name="module_work_network_security_groups"></a> [work\_network\_security\_groups](#module\_work\_network\_security\_groups) | github.com/danielkhen/network_security_group_module | n/a |
| <a name="module_work_route_tables"></a> [work\_route\_tables](#module\_work\_route\_tables) | github.com/danielkhen/route_table_module | n/a |
| <a name="module_work_storage_account"></a> [work\_storage\_account](#module\_work\_storage\_account) | github.com/danielkhen/storage_account_module | n/a |
| <a name="module_work_virtual_network"></a> [work\_virtual\_network](#module\_work\_virtual\_network) | github.com/danielkhen/virtual_network_module | n/a |
| <a name="module_work_vm"></a> [work\_vm](#module\_work\_vm) | github.com/danielkhen/virtual_machine_module | n/a |
<!-- END_TF_DOCS -->