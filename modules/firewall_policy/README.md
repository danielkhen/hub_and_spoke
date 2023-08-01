<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_rule_collection_groups"></a> [application\_rule\_collection\_groups](#input\_application\_rule\_collection\_groups) | (Optional) A list of all the rule collection groups of type application. | <pre>list(object({<br>    name     = string<br>    priority = number<br>    rule_collections = list(object({<br>      name     = string<br>      action   = string<br>      priority = number<br>      rules = list(object({<br>        name                  = string<br>        source_addresses      = optional(list(string), null)<br>        source_ip_groups      = optional(list(string), null)<br>        terminate_tls         = optional(bool, null)<br>        destination_addresses = optional(list(string), null)<br>        destination_fqdns     = optional(list(string), null)<br>        destination_fqdn_tags = optional(list(string), null)<br>        destination_urls      = optional(list(string), null)<br>        web_categories        = optional(list(string), null)<br>        protocols = list(object({<br>          type = string<br>          port = string<br>        }))<br>      }))<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_dns_proxy_enabled"></a> [dns\_proxy\_enabled](#input\_dns\_proxy\_enabled) | (Optional) Should dns proxy be enabled on linked firewalls. | `bool` | `false` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | (Optional) A list of dns servers ip addresses. | `list(string)` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location of the firewall policy. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the firewall policy. | `string` | n/a | yes |
| <a name="input_nat_rule_collection_groups"></a> [nat\_rule\_collection\_groups](#input\_nat\_rule\_collection\_groups) | (Optional) A list of all the rule collection groups of type nat. | <pre>list(object({<br>    name     = string<br>    priority = number<br>    rule_collections = list(object({<br>      name     = string<br>      action   = string<br>      priority = number<br>      rules = list(object({<br>        name                = string<br>        source_addresses    = optional(list(string), null)<br>        source_ip_groups    = optional(list(string), null)<br>        protocols           = list(string)<br>        destination_ports   = list(string)<br>        destination_address = string<br>        translated_address  = optional(string, null)<br>        translated_fqdn     = optional(string, null)<br>        translated_port     = string<br>      }))<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_network_rule_collection_groups"></a> [network\_rule\_collection\_groups](#input\_network\_rule\_collection\_groups) | (Optional) A list of all the rule collection groups of type network. | <pre>list(object({<br>    name     = string<br>    priority = number<br>    rule_collections = list(object({<br>      name     = string<br>      action   = string<br>      priority = number<br>      rules = list(object({<br>        name                  = string<br>        source_addresses      = optional(list(string), null)<br>        source_ip_groups      = optional(list(string), null)<br>        protocols             = list(string)<br>        destination_ports     = list(string)<br>        destination_addresses = optional(list(string), null)<br>        destination_fqdns     = optional(list(string), null)<br>        destination_ip_groups = optional(list(string), null)<br>      }))<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The resource group name for the firewall policy. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The id of the firewall policy. |
| <a name="output_name"></a> [name](#output\_name) | The name of the firewall policy. |
| <a name="output_object"></a> [object](#output\_object) | The firewall policy object. |

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall_policy.policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy) | resource |
| [azurerm_firewall_policy_rule_collection_group.application_rule_collection_groups](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | resource |
| [azurerm_firewall_policy_rule_collection_group.nat_rule_collection_groups](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | resource |
| [azurerm_firewall_policy_rule_collection_group.network_rule_collection_groups](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | resource |

## Example Code

```hcl
module "firewall_policy" {
  source = "github.com/danielkhen/firewall_policy_module"

  name                = "example-firewall-policy"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.example.name

  # View variable documentation
  network_rule_collection_groups     = local.network_rule_collection_groups
  application_rule_collection_groups = local.application_rule_collection_groups
  nat_rule_collection_groups         = local.nat_rule_collection_groups

  dns_proxy_enabled = true
  dns_servers       = ["10.0.0.10"]
}
```
<!-- END_TF_DOCS -->