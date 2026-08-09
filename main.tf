resource "azurerm_resource_group" "rg_vm" {
  for_each = var.rgs
  name     = each.value.name
  location = each.value.location
}

resource "azurerm_virtual_network" "vnets" {
  depends_on          = [azurerm_resource_group.rg_vm]
  for_each            = var.vnets
  name                = each.value.name
  address_space       = each.value.address_space
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_subnet" "vsubnet" {
  depends_on           = [azurerm_virtual_network.vnets]
  for_each             = var.vsubnets
  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes
}

resource "azurerm_network_interface" "vnic" {
  depends_on          = [azurerm_subnet.vsubnet]
  for_each            = var.vnics
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.vsubnet[each.value.subnet_id].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main_vm" {
  depends_on            = [azurerm_network_interface.vnic]
  for_each              = var.main_vm
  name                  = each.value.name
  location              = each.value.location
  resource_group_name   = each.value.resource_group_name
  network_interface_ids = [azurerm_network_interface.vnic[each.value.network_interface_ids[0]].id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}