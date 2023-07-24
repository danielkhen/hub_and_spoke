variable "name" {
  description = "(Required) The name of the route table."
  type        = string
}

variable "location" {
  description = "(Required) The location of the route table."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The resource group name of the route table."
  type        = string
}

variable "routes" {
  description = "(Optional) A list of all the routes"
  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string, null)
  }))
}