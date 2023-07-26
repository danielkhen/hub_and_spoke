variable "resource_group_name" {
  description = "The local resource group name for the peerings"
  type        = string
}

variable "remote_resource_group_name" {
  description = "The remote resource group name for the peerings"
  type        = string
}

variable "vnet_name" {
  description = "The name of the local vnet with the gateway"
  type        = string
}

variable "remote_vnet_name" {
  description = "The name of the remote vnet"
  type        = string
}

variable "vnet_id" {
  description = "The id of the local vnet with the gateway"
  type        = string
}

variable "remote_vnet_id" {
  description = "The id of the remote vnet"
  type        = string
}

variable "allow_forwarded_traffic" {
  description = "(Optional) Allow forwarded traffic through an nva."
  type        = bool
  default     = false
}

variable "use_local_gateway" {
  description = "(Optional) Use the local virtual network gateway for the peering."
  type        = bool
  default     = false
}