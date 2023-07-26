variable "name" {
  description = "(Required) The name of the log analytics workspace."
  type        = string
}

variable "location" {
  description = "(Required) The location of the log analytics workspace."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The resource group name of the log analytics workspace."
  type        = string
}

variable "virtual_network_id" {
  description = "(Required) The id of the virtual network linked to the private dns resolver."
  type        = string
}

variable "log_analytics_enabled" {
  description = "(Optional) Should all logs be sent to a log analytics workspace."
  type        = bool
  default     = false
}

variable "inbound_endpoint_name" {
  description = "(Optional) The name of the inbound endpoint of the private dns resolver."
  type        = string
  default     = "inbound"
}

variable "inbound_endpoint_subnet_id" {
  description = "(Required) The subnet id of the inbound endpoint of the private dns resolver."
  type        = string
}

variable "log_analytics_id" {
  description = "(Optional) The id of the log analytics workspace."
  type        = string
  default     = null
}

variable "diagnostics_name" {
  description = "(Optional) The name of the diagnostic settings of the private dns resolver."
  type        = string
  default     = "resolver-diagnostics"
}