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
  description = "(Required) The SKU of the log analytics workspace."
  type        = string
}

variable "internet_ingestion_enabled" {
  description = "(Optional) Should the log analytics workspace support ingestion over the public internet."
  type        = string
  default     = "true"
}

variable "internet_query_enabled" {
  description = "(Optional) Should the log analytics workspace support querying over the public internet."
  type        = string
  default     = "true"
}

variable "log_analytics" {
  description = "(Optional) Use a log analytics workspace to capture logs and metrics."
  type        = bool
  default     = false
}

variable "diagnostic_settings_name" {
  description = "(Optional) The name of the diagnostic settings."
  type        = string
  default     = "log-analytics-workspace-diagnostics"
}