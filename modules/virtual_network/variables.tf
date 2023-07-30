variable "name" {
  description = "(Required) The name of the virtual network."
  type        = string
}

variable "location" {
  description = "(Required) The location of the virtual network."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The resource group name of the virtual network."
  type        = string
}

variable "address_space" {
  description = "(Required) A list of the address prefixes of the virtual network."
  type        = list(string)
}

variable "dns_servers" {
  description = "(Optional) A list of the dns servers of the virtual network."
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "(Required) A list of all of the subnets in the virtual network."
  type = list(object({
    name                      = string
    address_prefixes            = list(string)
    network_security_group_id = optional(string, "")
    route_table_id            = optional(string, "")
  }))
}