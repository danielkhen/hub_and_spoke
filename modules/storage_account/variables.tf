variable "name" {
  description = "(Required) The name of the storage account."
  type        = string
}

variable "location" {
  description = "(Required) The location of the storage account."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The resource group name of the storage account."
  type        = string
}

variable "account_tier" {
  description = "(Required) The tier of the storage account."
  type        = string
}

variable "account_replication_type" {
  description = "(Required) The type of replication used for this storage account."
  type        = string
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

variable "enable_https_traffic_only" {
  description = "(Optional) Use only https traffic."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "(Optional) Allow public network access."
  type        = bool
  default     = false
}

variable "diagnostics_name" {
  description = "(Optional) The name of the diagnostic settings of the storage account."
  type        = string
  default     = "storage-diagnostics"
}

variable "subresources_diagnostics" {
  description = "(Optional) A list of the subresource to add diagnostic settings to."
  type = list(object({
    name             = string
    diagnostics_name = string
  }))
  default = [
    {
      name             = "blob"
      diagnostics_name = "blob-diagnostics"
    },
    {
      name             = "queue"
      diagnostics_name = "queue-diagnostics"
    },
    {
      name             = "file"
      diagnostics_name = "file-diagnostics"
    },
    {
      name             = "table"
      diagnostics_name = "table-diagnostics"
    }
  ]
}