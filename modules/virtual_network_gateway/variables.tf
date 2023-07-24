variable "name" {
  description = "(Required) The name for the virtual network gateway."
  type        = string
}

variable "location" {
  description = "(Required) The location of the virtual network gateway."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The resource group name of the virtual network gateway."
  type        = string
}

variable "type" {
  description = "(Required) The type of the virtual network gateway, Vpn or ExpressRoute."
  type        = string

  validation {
    condition     = contains(["Vpn", "ExpressRoute"], var.type)
    error_message = "Type should be Vpn or ExpressRoute."
  }
}

variable "vpn_type" {
  description = "(Optional) The type of the virtual network gateway, RouteBased or PolicyBased."
  type        = string
  default     = "RouteBased"

  validation {
    condition     = contains(["RouteBased", "PolicyBased"], var.vpn_type)
    error_message = "Type should be RouteBased or PolicyBased."
  }
}

variable "sku" {
  description = "(Required) The SKU of the virtual network gateway."
  type        = string

  validation {
    condition = contains(["Basic", "Standard", "HighPerformance", "UltraPerformance", "ErGw1AZ", "ErGw2AZ", "ErGw3AZ",
    "VpnGw1", "VpnGw2", "VpnGw3", "VpnGw4", "VpnGw5", "VpnGw1AZ", "VpnGw2AZ", "VpnGw3AZ", "VpnGw4AZ", "VpnGw5AZ"], var.sku)
    error_message = "SKU not valid."
  }
}

variable "generation" {
  description = "(Optional) The generation of the virtual network gateway."
  type        = string
  default     = "None"

  validation {
    condition     = contains(["Generation1", "Generation2", "None"], var.generation)
    error_message = "Generation should be Generation1, Generation2 or None"
  }
}

variable "subnet_id" {
  description = "(Required) The id of the gateway subnet"
  type        = string
}

variable "default_pip_name" {
  description = "(Required) The name for the public ip of the default ip configuration."
  type        = string
}

variable "active_active" {
  description = "(Required) Is the virtual network gateway in active active mode."
  type        = bool
}

variable "aa_pip_name" {
  description = "(Optional) The name for the public ip of the active active ip configuration, Required if active-active mode is enabled."
  type        = string
  default     = null
}

variable "vpn_address_space" {
  description = "(Optional) The vpn address space for client private ips."
  type        = list(string)
  default     = null
}

variable "vpn_client_protocols" {
  description = "(Optional) list of protocols supported by the vpn client, OpenVPN, SSTP or IkeV2."
  type        = list(string)
  default     = ["OpenVPN"]

  validation {
    condition     = alltrue([for protocol in var.vpn_client_protocols : contains(["OpenVPN", "SSTP", "IkeV2"], protocol)])
    error_message = "Vpn protocols supported values are OpenVPN, SSTP or IkeV2."
  }
}

variable "vpn_auth_types" {
  description = "(Optional) List of vpn authentication types, AAD, Radius or Certificate, Required when using multiple vpn client protocols."
  type        = list(string)
  default     = ["AAD"]

  validation {
    condition     = alltrue([for protocol in var.vpn_auth_types : contains(["AAD", "Radius", "Certificate"], protocol)])
    error_message = "Vpn authentication protocols supported values are AAD, Radius and Certificate."
  }
}

variable "aad_tenant" {
  description = "(Optional) The aad tenant id, Required for AAD authentication."
  type        = string
  default     = null
  sensitive   = true
}

variable "aad_audience" {
  description = "(Optional) The aad audience id, Required For aad authentication."
  type        = string
  default     = null
}

variable "radius_server_address" {
  description = "(Optional) The address of the radius server, Required for radius authentication."
  type        = string
  default     = null
}

variable "radius_server_secret" {
  description = "(Optional) The secret of the radius server, Required for radius authentication."
  type        = string
  default     = null
  sensitive   = true
}

variable "root_certificate" {
  description = "(Optional) The root certificate block, Required for certificate authentication."
  type = object({
    name             = string
    public_cert_data = string
  })
  default = null
}

variable "revoked_certificate" {
  description = "(Optional) The revoked certificate block, Required for certificate authentication."
  type = object({
    name       = string
    thumbprint = string
  })
  default = null
}

variable "log_analytics_id" {
  description = "(Optional) The id of the log analytics workspace."
  type        = string
  default     = null
}

variable "vng_diagnostics_name" {
  description = "(Optional) The name of the diagnostic settings of the virtual network gateway."
  type        = string
  default     = "vng-diagnostics"
}

variable "default_pip_diagnostics_name" {
  description = "(Optional) The name of the diagnostic settings of the default public ip."
  type        = string
  default     = "default-pip-diagnostics"
}

variable "aa_pip_diagnostics_name" {
  description = "(Optional) The name of the diagnostic settings of the active-active public ip."
  type        = string
  default     = "aa-pip-diagnostics"
}

variable "default_ip_configuration_name" {
  description = "(Optional) The name of the default ip configuration."
  type        = string
  default     = "default"
}

variable "aa_ip_configuration_name" {
  description = "(Optional) The name of the active-active ip configuration."
  type        = string
  default     = "active-active"
}