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

variable "sku" {
  description = "(Optional) The SKU of the log analytics workspace."
  type        = string
  default     = "PerGB2018"

  validation {
    condition     = contains(["Free", "PerNode", "Premium", "Standard", "Standalone", "Unlimited", "CapacityReservation", "PerGB2018"], var.sku)
    error_message = "SKU possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018."
  }
}

variable "internet_ingestion_enabled" {
  description = "(Optional) Should the log analytics workspace support ingestion over the public internet."
  type        = bool
  default     = false
}

variable "internet_query_enabled" {
  description = "(Optional) Should the log analytics workspace support querying over the public internet."
  type        = bool
  default     = false
}

variable "log_analytics_enabled" {
  description = "(Optional) Should logs be sent to itself."
  type        = bool
  default     = false
}

variable "diagnostic_settings_name" {
  description = "(Optional) The name of the diagnostic settings."
  type        = string
  default     = "log-analytics-workspace-diagnostics"
}