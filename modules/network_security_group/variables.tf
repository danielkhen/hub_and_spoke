variable "name" {
  description = "(Required) The name of the network security group."
  type        = string
}

variable "location" {
  description = "(Required) The location of the network security group."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The resource group name of the network security group."
  type        = string
}

variable "log_analytics_id" {
  description = "(Optional) The id of the log analytics workspace."
  type        = string
  default     = null
}

variable "diagnostic_settings_name" {
  description = "(Optional) The name of the diagnostic settings."
  type        = string
  default     = "network-security-group-diagnostics"
}

variable "network_security_rules" {
  description = "(Optional) A list of network security rules."
  type = list(object({
    name                       = string
    access                     = string
    direction                  = string
    priority                   = number
    protocol                   = string
    source_address_prefix      = string
    source_port_range          = string
    destination_address_prefix = string
    destination_port_range     = string
  }))
  default = []
}