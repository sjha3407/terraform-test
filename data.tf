# #data "azurerm_subnet" "internal" {
#     depends_on = [ azurerm_virtual_network.vnets ]
#   name                 = "internal"
#   virtual_network_name = "vnet_vm"
#   resource_group_name  = "rg_vm"
# }

# output "subnet_id" {
#   value = data.azurerm_subnet.internal.id
# }

# #data "azurerm_network_interface" "vnic" {
#     depends_on          = [azurerm_subnet.vsubnet]
#   name                = "nic_vm"
#   resource_group_name = "rg_vm"
# }

# output "network_interface_id" {
#   value = data.azurerm_network_interface.vnic.id
# }