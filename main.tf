resource "azurerm_resource_group" "myRG" {
  name = var.resource_group_name
  location = "Central India"
}

resource "azurerm_virtual_network" "my_VN" {
  name = "example-network"
  location = azurerm_resource_group.myRG.location
  resource_group_name = azurerm_resource_group.myRG.name
  address_space = var.vnet_cidr_block
}

resource "azurerm_subnet" "my_subnet" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.myRG.name
  virtual_network_name = azurerm_virtual_network.my_VN.name
  address_prefixes     = var.subnet_cidr_block
}

resource "azurerm_network_security_group" "my_NSG" {
  name = "example-nsg"
  location = azurerm_resource_group.myRG.location
  resource_group_name = azurerm_resource_group.myRG.name
  security_rule {
    name = "allow-ssh"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 22
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "my_PIP" {
  name = "example-public-ip"
  location = azurerm_resource_group.myRG.location
  resource_group_name = azurerm_resource_group.myRG.name
  allocation_method = "Static"
}

resource "azurerm_network_interface" "my_NIC" {
  name = "example-nic"
  location = azurerm_resource_group.myRG.location
  resource_group_name = azurerm_resource_group.myRG.name
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.my_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.my_PIP.id
  }
}

resource "azurerm_network_interface_security_group_association" "my_NIC_association" {
  network_interface_id      = azurerm_network_interface.my_NIC.id
  network_security_group_id = azurerm_network_security_group.my_NSG.id
}

resource "azurerm_linux_virtual_machine" "myVM" { 
  name                            = "myVM" 
  resource_group_name             = azurerm_resource_group.myRG.name 
  location                        = azurerm_resource_group.myRG.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password 
  disable_password_authentication = false 

  network_interface_ids = [ 
    azurerm_network_interface.my_NIC.id 
  ] 

  os_disk { 
    caching              = "ReadWrite" 
    storage_account_type = "Standard_LRS" 
  } 

  source_image_reference { 
    publisher = var.image_publisher
    offer     = var.image_offer 
    sku       = var.image_sku
    version   = var.image_version
  } 
 } 