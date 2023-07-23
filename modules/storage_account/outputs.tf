output "name" {
  description = "The name of the storage account."
  value       = azurerm_storage_account.storage.name
}

output "id" {
  description = "The id of the storage account."
  value       = azurerm_storage_account.storage.id
}

output "object" {
  description = "The storage account object."
  value       = azurerm_storage_account.storage
}
