variable "name" {
  description = "(Required) The name for the virtual network gateway."
  type        = string
}

variable "location" {
  description = "(Required) The location of the virtual network gateway."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The resource group name of the virtual network gateway."
  type        = string
}

variable "type" {
  description = "(Required) The type of the virtual network gateway, Vpn or ExpressRoute."
  type        = string
}

variable "vpn_type" {
  description = "(Optional) The type of the virtual network gateway, RouteBased or PolicyBased."
  type        = string
  default     = "RouteBased"
}

variable "sku" {
  description = "(Required) The SKU of the virtual network gateway."
  type        = string
}

variable "generation" {
  description = "(Optional) The generation of the virtual network gateway."
  type        = string
  default     = "None"
}

variable "subnet_id" {
  description = "(Required) The id of the gateway subnet"
  type        = string
}

variable "default_pip_name" {
  description = "(Required) The name for the public ip of the default ip configuration."
  type        = string
}

variable "active_active" {
  description = "(Required) Is the virtual network gateway in active active mode."
  type        = bool
}

variable "aa_pip_name" {
  description = "(Optional) The name for the public ip of the active active ip configuration, Required if active-active mode is enabled."
  type        = string
  default     = null
}

variable "vpn_address_space" {
  description = "(Optional) The vpn address space for client private ips."
  type        = list(string)
  default     = null
}

variable "aad_tenant" {
  description = "(Optional) The aad tenant id, Required if the vpn address space is assigned."
  type        = string
  default     = null
  sensitive   = true
}

variable "aad_audience" {
  description = "(Optional) The aad audience id, Required if the vpn address space is assigned."
  type        = string
  default     = null
}

variable "log_analytics" {
  description = "(Optional) Use a log analytics workspace to capture logs and metrics."
  type        = bool
  default     = false
}
variable "log_analytics_id" {
  description = "(Optional) The id of the log analytics workspace, Required when log analytics enabled."
  type        = string
  default     = null
}

variable "vng_diagnostics_name" {
  description = "(Optional) The name of the diagnostic settings of the virtual network gateway."
  type        = string
  default     = "vng-diagnostics"
}

variable "default_pip_diagnostics_name" {
  description = "(Optional) The name of the diagnostic settings of the default public ip."
  type        = string
  default     = "default-pip-diagnostics"
}

variable "aa_pip_diagnostics_name" {
  description = "(Optional) The name of the diagnostic settings of the active-active public ip."
  type        = string
  default     = "aa-pip-diagnostics"
}

variable "default_ip_configuration_name" {
  description = "(Optional) The name of the default ip configuration."
  type        = string
  default     = "default"
}

variable "aa_ip_configuration_name" {
  description = "(Optional) The name of the active-active ip configuration."
  type        = string
  default     = "active-active"
}