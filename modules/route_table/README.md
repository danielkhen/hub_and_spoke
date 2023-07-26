<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | (Required) The location of the route table. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the route table. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The resource group name of the route table. | `string` | n/a | yes |
| <a name="input_routes"></a> [routes](#input\_routes) | (Optional) A list of all the routes | <pre>list(object({<br>    name                   = string<br>    address_prefix         = string<br>    next_hop_type          = string<br>    next_hop_in_ip_address = optional(string, null)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The id of the route table. |
| <a name="output_name"></a> [name](#output\_name) | The name of the route table. |
| <a name="output_object"></a> [object](#output\_object) | The route table object. |

## Resources

| Name | Type |
|------|------|
| [azurerm_route.routes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route_table.rt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |

## Example Code

```hcl
module "route_table" {
  source = "github.com/danielkhen/route_table_module"

  name                = "example-rt"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.example.name
  routes              = local.routes # View variable documentation
}
```
<!-- END_TF_DOCS -->