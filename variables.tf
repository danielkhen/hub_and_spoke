variable "vm_admin_password" {
  description = "(Optional) The username for the admin user in the virtual machines."
  type        = string
  sensitive   = true
  default     = null
}

variable "aad_tenant_id" {
  description = "(Required) The aad tenant id."
  type        = string
  sensitive   = true
}