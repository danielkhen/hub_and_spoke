variable "name" {
  description = "(Required) The name of the kubernetes cluster."
  type        = string
}

variable "location" {
  description = "(Required) The location of the kubernetes cluster."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The resource group name of the kubernetes cluster."
  type        = string
}

variable "node_pools" {
  description = "(Required) A list of node pools, there must be exactly one node pool where the default property is true."
  type = list(object({
    name                  = string
    node_count            = number
    vm_size               = string
    vnet_subnet_id        = string
    enable_auto_scaling   = optional(bool, false)
    default               = optional(bool, false)
    enable_node_public_ip = optional(bool, false)
  }))
}

variable "container_registry_id" {
  description = "(Optional) The id of the azure container registry to assign access to the cluster."
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

variable "diagnostics_name" {
  description = "(Optional) The name of the diagnostic setting of the kubernetes cluster."
  type        = string
  default     = "aks-diagnostics"
}

variable "network_plugin" {
  description = "(Optional) The network plugin of the aks, azure, kubenet or none."
  type        = string
  default     = "none"
}

variable "private_cluster_enabled" {
  description = "(Optional) Should the kubernetes api get a private ip address on the virtual network."
  type        = bool
  default     = true
}

variable "node_resource_group" {
  description = "(Required) The resource group name where all the components of the kubernetes cluster reside."
  type        = string
}

variable "dns_prefix" {
  description = "(Optional) The dns prefix for the kuberenetes api."
  type        = string
  default     = null
}