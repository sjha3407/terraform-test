rgs = {
  rg1 = {
    name     = "rg_vm"
    location = "central india"
  }
}
vnets = {
  vnet1 = {
    name                = "vnet_vm"
    address_space       = ["10.0.0.0/16"]
    location            = "central india"
    resource_group_name = "rg_vm"
  }
}
vsubnets = {
  vsubnet1 = {
    name                 = "internal"
    resource_group_name  = "rg_vm"
    virtual_network_name = "vnet_vm"
    address_prefixes     = ["10.0.1.0/24"]


  }

}
vnics = {
  vnic1 = {
    name                = "nic_vm"
    resource_group_name = "rg_vm"
    location            = "central india"
    subnet_id           = "vsubnet1"
  }
}

main_vm = {
    vm1 = {
  name                  = "main_vm"
  resource_group_name   = "rg_vm"
  location              = "central india"
  network_interface_ids = ["vnic1"]
 
}

}