# Terraform

This Hub and Spoke Architecture environment consists of 3 resource groups, 1 Hub and 2 Spoke, with their own VNets. 
For the security layer, Azure Firewall protects the perimeter of the traffic. 
An Application Gateway is used to load balancing app traffic to the IIS web servers deployed in the spokes. 
At the VM layer, ADDS is deployed at the hub VM, with the spoke VMs domain joined. 
A Virtual Network Gateway is also included in this architecture to establish S2S or P2S connectivity to the environment from on-premises.
