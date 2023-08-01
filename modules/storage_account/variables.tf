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

  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "The account tier should be Standard or Premium."
  }
}

variable "account_replication_type" {
  description = "(Required) The type of replication used for this storage account."
  type        = string

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "Replication type possible values are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS."
  }
}

variable "account_kind" {
  description = "(Optional) The kind of the storage account."
  type        = string
  default     = "StorageV2"

  validation {
    condition     = contains(["BlobStorage", "BlockBlobStorage", "FileStorage", "Storage", "StorageV2"], var.account_kind)
    error_message = "Account kind possible values are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2."
  }
}

variable "access_tier" {
  description = "(Optional) The access tier of the storage account."
  type        = string
  default     = "Hot"

  validation {
    condition     = contains(["Hot", "Cool"], var.access_tier)
    error_message = "Access tier should be Hot or Cold."
  }
}

variable "log_analytics_id" {
  description = "(Required) The id of the log analytics workspace."
  type        = string
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

variable "private_endpoint_enabled" {
  description = "(Optional) Should the container registry have a private endpoint."
  type        = bool
  default     = false
}

variable "private_dns_enabled" {
  description = "(Optional) Should the private endpoint be attached to a private dns zone."
  type        = bool
  default     = false
}

variable "private_endpoints_subnet_id" {
  description = "(Optional) The subnet id of the private endpoints."
  type        = string
  default     = false
}

variable "private_endpoints" {
  description = "(Optional) A list of private endpoints of the storage subresources."
  type = list(object({
    name             = string
    nic_name         = string
    subresource_name = string
    dns_name         = optional(string)
  }))
  default = []
}

variable "vnet_links" {
  description = "(Optional) A list of virtual networks to link with the private dns zone."
  type = list(object({
    name    = string
    vnet_id = string
  }))
  default = []
}