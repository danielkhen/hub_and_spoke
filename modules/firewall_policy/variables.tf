variable "name" {
  description = "(Required) The name of the firewall policy."
  type        = string
}

variable "location" {
  description = "(Required) The location of the firewall policy."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The resource group name for the firewall policy."
  type        = string
}

variable "network_rule_collection_groups" {
  description = "(Optional) A list of all the rule collection groups of type network."
  type = list(object({
    name     = string
    priority = number
    rule_collections = list(object({
      name     = string
      action   = string
      priority = number
      rules = list(object({
        name                  = string
        source_addresses      = list(string)
        protocols             = list(string)
        # TODO add all options for addresses (ip, fqdn) and make them optional
        destination_ports     = list(string)
        destination_addresses = list(string)
      }))
    }))
  }))
  default = []
}

variable "application_rule_collection_groups" {
  description = "(Optional) A list of all the rule collection groups of type application."
  type = list(object({
    name     = string
    priority = number
    rule_collections = list(object({
      name     = string
      action   = string
      priority = number
      rules = list(object({
        name                  = string
        source_addresses      = list(string)
        destination_fqdns     = optional(list(string), [])
        destination_fqdn_tags = optional(list(string), [])
        protocols = list(object({
          type = string
          port = string
        }))
      }))
    }))
  }))
  default = []
}

variable "nat_rule_collection_groups" {
  description = "(Optional) A list of all the rule collection groups of type nat."
  type = list(object({
    name     = string
    priority = number
    rule_collections = list(object({
      name     = string
      action   = string
      priority = number
      rules = list(object({
        name                = string
        source_addresses    = list(string)
        protocols           = list(string)
        destination_ports   = list(string)
        destination_address = string
        translated_address  = string
        translated_port     = string
      }))
    }))
  }))
  default = []
}

variable "dns_proxy_enabled" {
  description = "(Optional) Should dns proxy be enabled on linked firewalls."
  type        = bool
  default     = false
}

variable "dns_servers" {
  description = "(Optional) A list of dns servers ip addresses."
  type        = list(string)
  default     = null
}