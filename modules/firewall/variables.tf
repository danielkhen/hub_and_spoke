variable "name" {
  description = "(Required) The name of the firewall."
  type        = string
}

variable "location" {
  description = "(Required) The location of the firewall."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The resource group name of the firewall."
  type        = string
}

variable "sku_tier" {
  description = "(Required) The SKU tier of the firewall, Basic, Standard or Premium."
  type        = string

  validation {
    condition     = contains(["Premium", "Standard", "Basic"], var.sku_tier)
    error_message = "SKU tier should be Premium, Standard or Basic."
  }
}

variable "policy_id" {
  description = "(Optional) The id of the firewall policy."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "(Required) The id of the firewall subnet."
  type        = string
}

variable "management_subnet_id" {
  description = "(Optional) The id of the firewall management subnet, Required if forced tunneling is enabled."
  type        = string
  default     = null
}

variable "public_ip_name" {
  description = "(Required) The name for the regular public ip."
  type        = string
}

variable "forced_tunneling" {
  description = "(Optional) Is forced tunneling enabled."
  type        = bool
  default     = false
}

variable "management_public_ip_name" {
  description = "(Optional) The name for the management public ip, Required if forced tunneling is enabled."
  type        = string
  default     = null
}

variable "log_analytics_id" {
  description = "(Required) The id of the log analytics workspace."
  type        = string
}