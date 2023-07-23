#TODO support adding a disk, with its constraints as validations.
locals {
  ip_allocation_method = "Dynamic"
  is_windows           = var.os_type == "windows"
}


resource "azurerm_network_interface" "nics" {
  count = var.vm_count

  name                = var.vm_count == 1 ? var.nic_name : "${var.nic_name}-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = local.ip_allocation_method
  }

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

resource "azurerm_windows_virtual_machine" "vms" {
  #TODO Test linux and windows vms
  count = local.is_windows ? var.vm_count : 0

  name                = var.vm_count == 1 ? var.name : "${var.name}-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.size

  network_interface_ids = [
    azurerm_network_interface.nics[count.index].id
  ]

  admin_username = var.admin_username
  admin_password = var.admin_password

  os_disk {
    #TODO test disk
    name                             = var.os_disk.name
    caching                          = var.os_disk.caching
    storage_account_type             = var.os_disk.storage_account_type
    disk_encryption_set_id           = var.os_disk.disk_encryption_set_id
    disk_size_gb                     = var.os_disk.disk_size_gb
    write_accelerator_enabled        = var.os_disk.write_accelerator_enabled
    secure_vm_disk_encryption_set_id = var.os_disk.secure_vm_disk_encryption_set_id
    security_encryption_type         = var.os_disk.security_encryption_type

    dynamic "diff_disk_settings" {
      for_each = var.os_disk.diff_disk_settings != null ? [] : [true]

      content {
        option    = var.os_disk.diff_disk_settings.option
        placement = var.os_disk.diff_disk_settings.placement
      }
    }
  }

  dynamic "source_image_reference" {
    #TODO test source image
    for_each = var.source_image_reference == null ? [] : [true]

    content {
      offer     = var.source_image_reference.offer
      publisher = var.source_image_reference.publisher
      sku       = var.source_image_reference.sku
      version   = var.source_image_reference.version
    }
  }

  dynamic "identity" { #TODO test identities
    for_each = var.identity_type == null ? [] : [true]

    content {
      type         = var.identity_type
      identity_ids = var.user_assigned_identities
    }
  }

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

resource "azurerm_linux_virtual_machine" "vms" {
  count = local.is_windows ? 0 : var.vm_count

  name                = var.vm_count == 1 ? var.name : "${var.name}-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.size

  network_interface_ids = [
    azurerm_network_interface.nics[count.index].id
  ]

  disable_password_authentication = var.disable_password_authentication
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password

  os_disk {
    name                             = var.os_disk.name
    caching                          = var.os_disk.caching
    storage_account_type             = var.os_disk.storage_account_type
    disk_encryption_set_id           = var.os_disk.disk_encryption_set_id
    disk_size_gb                     = var.os_disk.disk_size_gb
    write_accelerator_enabled        = var.os_disk.write_accelerator_enabled
    secure_vm_disk_encryption_set_id = var.os_disk.secure_vm_disk_encryption_set_id
    security_encryption_type         = var.os_disk.security_encryption_type

    dynamic "diff_disk_settings" {
      for_each = var.os_disk.diff_disk_settings == null ? [] : [true]

      content {
        option    = var.os_disk.diff_disk_settings.option
        placement = var.os_disk.diff_disk_settings.placement
      }
    }
  }

  source_image_reference {
    offer     = var.source_image_reference.offer
    publisher = var.source_image_reference.publisher
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  dynamic "identity" {
    for_each = var.identity_type == null ? [] : [true]

    content {
      type         = var.identity_type
      identity_ids = var.user_assigned_identities
    }
  }

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

module "nic_diagnostics" {
  source = "../diagnostic_setting"
  count  = var.vm_count

  name                       = var.nic_diagnostics_name
  target_resource_id         = azurerm_network_interface.nics[count.index].id
  log_analytics_workspace_id = var.log_analytics_id
  enabled                    = var.log_analytics
}

locals {
  role_assignements_map = merge([
    for count in range(var.vm_count) : {
      for role_assignment in var.role_assignments : "vm${count}_${role_assignment.role}_${role_assignment.scope}" => merge(role_assignment, {
        principal_id = local.is_windows ? azurerm_windows_virtual_machine.vms[count].identity[0].principal_id : azurerm_linux_virtual_machine.vms[count].identity[0].principal_id
      })
    }
  ]...)
}

resource "azurerm_role_assignment" "vm_roles" {
  for_each = local.role_assignements_map

  principal_id         = each.value.principal_id
  role_definition_name = each.value.role
  scope                = each.value.scope
}