resource "azurerm_resource_group" "myRG" {
  name = "myRG"
  location = "Central India"
}

resource "azurerm_virtual_network" "my_VN" {
  name = "example-network"
  location = azurerm_resource_group.myRG.location
  resource_group_name = azurerm_resource_group.myRG.name
  address_space = [ "192.168.0.0/16" ]
}

resource "azurerm_subnet" "my_subnet" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.myRG.name
  virtual_network_name = azurerm_virtual_network.my_VN.name
  address_prefixes     = ["192.168.1.0/24"]
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
    source_port_range          = 22
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
  size                            = "Standard_B1s" 
  admin_username                  = "azureuser" 
  admin_password                  = "P@ssw0rd1234!" 
  disable_password_authentication = false 

  network_interface_ids = [ 
    azurerm_network_interface.myNIC.id, 
  ] 

  os_disk { 
    caching              = "ReadWrite" 
    storage_account_type = "Standard_LRS" 
  } 

  source_image_reference { 
    publisher = "Canonical" 
    offer     = "UbuntuServer" 
    sku       = "18.04-LTS" 
    version   = "latest" 
  } 
 } 