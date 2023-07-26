variable "name" {
  description = "(Required) The name of the private endpoint."
  type        = string
}

variable "location" {
  description = "(Required) The location of the private endpoint and private dns zone."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group."
  type        = string
}

variable "private_dns_enabled" {
  description = "(Optional) Should a private dns zone be included."
  type        = bool
  default     = false
}

variable "dns_name" {
  description = "(Optional) The name of the private dns zone, Required if private dns is enabled."
  type        = string
  default     = null
}

variable "vnet_links" {
  description = "(Optional) A list of virtual networks to link with the dns zone."
  type = list(object({
    vnet_id = string
    name    = string
  }))
  default = []
}


variable "subnet_id" {
  description = "(Required) The subnet id for the private endpoint."
  type        = string
}

variable "nic_name" {
  description = "(Optional) The name of the network interface of the private endpoint."
  type        = string
  default     = null
}

variable "private_service_connection_name" {
  description = "(Optional) The name of the private service connection."
  type        = string
  default     = "private-connection"
}

variable "resource_id" {
  description = "(Required) The resource id to associate with the private endpoint."
  type        = string
}

variable "subresource_name" {
  description = "(Required) The subresource to associate with the private endpoint."
  type        = string
}

variable "dns_prefix" {
  description = "(Optional) The name of the private endpoint in the private dns zone."
  type        = string
  default     = "private-endpoint"
}

variable "log_analytics_enabled" {
  description = "(Optional) Should all logs be sent to a log analytics workspace."
  type        = bool
  default     = false
}

variable "log_analytics_id" {
  description = "(Optional) The id of the log analytics workspace."
  type        = string
  default     = null
}

variable "nic-diagnostics-name" {
  description = "(Optional) The name of the diagnostic settings for the network interface."
  type        = string
  default     = "pe-nic-diagnostics"
}