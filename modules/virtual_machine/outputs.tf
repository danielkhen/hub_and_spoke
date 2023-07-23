output "names" {
  description = "A list of all virtual machines names."
  value       = local.is_windows ? azurerm_windows_virtual_machine.vms[*].name : azurerm_linux_virtual_machine.vms[*].name
}

output "id" {
  description = "A list of all virtual machines ids."
  value       = local.is_windows ? azurerm_windows_virtual_machine.vms[*].id : azurerm_linux_virtual_machine.vms[*].id
}

output "objects" {
  description = "A list of all virtual machines."
  value       = local.is_windows ? azurerm_windows_virtual_machine.vms : azurerm_linux_virtual_machine.vms
}