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
        source_addresses      = optional(list(string), null)
        source_ip_groups      = optional(list(string), null)
        protocols             = list(string)
        destination_ports     = list(string)
        destination_addresses = optional(list(string), null)
        destination_fqdns     = optional(list(string), null)
        destination_ip_groups = optional(list(string), null)
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
        source_addresses      = optional(list(string), null)
        source_ip_groups      = optional(list(string), null)
        terminate_tls         = optional(bool, null)
        destination_addresses = optional(list(string), null)
        destination_fqdns     = optional(list(string), null)
        destination_fqdn_tags = optional(list(string), null)
        destination_urls      = optional(list(string), null)
        web_categories        = optional(list(string), null)
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
        source_addresses    = optional(list(string), null)
        source_ip_groups    = optional(list(string), null)
        protocols           = list(string)
        destination_ports   = list(string)
        destination_address = string
        translated_address  = optional(string, null)
        translated_fqdn     = optional(string, null)
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