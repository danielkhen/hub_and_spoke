variable "name" {
  description = "(Required) The name of the dns record."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group of the dns zone."
  type        = string
}

variable "dns_name" {
  description = "(Required) The name of the dns zone."
  type        = string
}

variable "record_type" {
  description = "(Required) The type of the dns record."
  type        = string

  validation {
    condition     = contains(["a", "aaaa"], var.record_type)
    error_message = "Current supported values for record type are a and aaaa."
  }
}

variable "is_private" {
  description = "(Optional) Is the dns zone private."
  type        = bool
  default     = true
}

variable "vnet_links" {
  description = "(Optional) A list of virtual networks to link with the dns zone, only needed when dns zone is private."
  type = list(object({
    vnet_id = string
    name    = string
  }))
  default = []
}

variable "records" {
  description = "(Optional) List of ipv4 addresses."
  type        = list(string)
  default     = null
}

variable "ttl" {
  description = "(Required) The time to live of the dns record."
  type        = number
  default     = 300
}
