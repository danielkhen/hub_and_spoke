variable "name" {
  description = "(Required) The name of the diagnostic setting."
  type        = string
}

variable "target_resource_id" {
  description = "(Required) The resource id to enable logs on."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "(Optional) The log analytics workspace id to send logs to."
  type        = string
  default     = null
}

variable "storage_account_id" {
  description = "(Optional) The storage account id to send logs to."
  type        = string
  default     = null
}