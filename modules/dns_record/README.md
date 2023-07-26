<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | (Required) The name of the dns zone. | `string` | n/a | yes |
| <a name="input_is_private"></a> [is\_private](#input\_is\_private) | (Optional) Is the dns zone private. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the dns record. | `string` | n/a | yes |
| <a name="input_record_type"></a> [record\_type](#input\_record\_type) | (Required) The type of the dns record. | `string` | n/a | yes |
| <a name="input_records"></a> [records](#input\_records) | (Required) List of ipv4 addresses. | `list(string)` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group of the dns zone. | `string` | n/a | yes |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | (Required) The time to live of the dns record. | `number` | `300` | no |
| <a name="input_vnet_links"></a> [vnet\_links](#input\_vnet\_links) | (Optional) A list of virtual networks to link with the dns zone, only needed when dns zone is private. | <pre>list(object({<br>    vnet_id = string<br>    name    = string<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_id"></a> [dns\_id](#output\_dns\_id) | The id of the dns zone. |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | The name of the dns zone. |
| <a name="output_dns_object"></a> [dns\_object](#output\_dns\_object) | The dns zone object. |
| <a name="output_record_id"></a> [record\_id](#output\_record\_id) | The id of the dns record. |
| <a name="output_record_name"></a> [record\_name](#output\_record\_name) | The name of the dns record. |
| <a name="output_record_object"></a> [record\_object](#output\_record\_object) | The dns record object. |

## Resources

| Name | Type |
|------|------|
| [azurerm_dns_a_record.record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_aaaa_record.record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_aaaa_record) | resource |
| [azurerm_dns_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |
| [azurerm_private_dns_a_record.record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_aaaa_record.record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_aaaa_record) | resource |
| [azurerm_private_dns_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.vnet_links](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |

## Example Code

```hcl
module "dns_record" {
  source = "github.com/danielkhen/dns_record_module"

  name                = "example-name"
  resource_group_name = azurerm_resource_group.example.name
  dns_name            = "example-dns.com"
  is_private          = true
  record_type         = "a"
  records             = ["10.0.0.10"]
  vnet_links = [ # Links to vnets in the case of a private dns.
    {
      name    = "example-link"
      vnet_id = azurerm_virtual_network.example.id
    }
  ]
}
```
<!-- END_TF_DOCS -->