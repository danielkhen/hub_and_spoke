variable "name" {
  description = "(Required) The name of the virtual machines."
  type        = string
}

variable "location" {
  description = "(Required) The location of the virtual machines."
  type        = string
}

variable "resource_group_name" {
  description = "(required) The resource group name of the virtual machines."
  type        = string
}

variable "subnet_id" {
  description = "(Required) The subnet id of the network interfaces."
  type        = string
}

variable "size" {
  description = "(Required) The size of the virtual machines."
  type        = string
}

variable "admin_username" {
  description = "(Optional) The username of the admin user in the virtual machines, Required when password authentication enabled."
  type        = string
  default     = null
}

variable "admin_password" {
  description = "(Optional) The username of the admin user in the virtual machines, Required when password authentication enabled."
  type        = string
  sensitive   = true
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

variable "identity_type" {
  description = "(Optional) The type of the identity of the virtual machines."
  type        = string
  default     = null
}

variable "role_assignments" {
  description = "(Optional) A list of rules for the system identity, system assigned identity must be enabled."
  type = list(object({
    scope = string
    role  = string
  }))
  default = []
}

variable "user_assigned_identities" {
  description = "(Optional) A list of ids of user assigned identities for each virtual machine, user assigned identity must be enabled."
  type        = list(string)
  default     = null
}

variable "nic_diagnostics_name" {
  description = "(Optional) The name of the network interface diagnostic setting."
  type        = string
  default     = "nic-diagnostics"
}

variable "nic_name" {
  description = "(Required) The name of the network interface."
  type        = string
}

variable "ip_configuration_name" {
  description = "(Optional) The name of the ip configuration of the network interface."
  type        = string
  default     = "default"
}

variable "os_type" {
  description = "(Required) The os type of the vm, linux or windows."
  type        = string
}

variable "disable_password_authentication" {
  description = "(Optional) Allow ssh connection in linux virtual machines."
  type        = string
  default     = false
}

variable "vm_count" {
  description = "(Optional) The number of virtual machines to create with this configurations."
  type        = number
  default     = 1
}

variable "source_image_reference" {
  description = "(Required) An object defining the source image for the virtual machines."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "os_disk" {
  description = "(Required) An object defining the disk containing the operation system for the virtual machines."
  type = object({
    caching                          = string
    storage_account_type             = string
    name                             = optional(string, null)
    disk_size_gb                     = optional(number, null)
    write_accelerator_enabled        = optional(bool, false)
    disk_encryption_set_id           = optional(string, null)
    secure_vm_disk_encryption_set_id = optional(string, null)
    security_encryption_type         = optional(string, null)
    diff_disk_settings = optional(object({
      option    = string
      placement = optional(string, null)
    }), null)
  })
}