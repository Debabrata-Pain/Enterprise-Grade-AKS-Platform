module "azure_devops_agent" {

  source = "../../modules/linux-vm"

  vm_name = "prod-ado-agent"

  location = var.location

  resource_group_name = module.shared_rg.resource_group_name

  subnet_id = module.agent_subnet.id

  vm_size = "Standard_B1s"

  admin_username = "azureuser"

  allowed_ssh_ip = "154.210.225.134/32"

  public_key = <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEPY/HreCXbnhNYDEIybc5cAi5kfPjUsl6IGV807pVvi DebabrataPain
EOF

  identity_ids = [
    module.azure_devops_agent_identity.id
  ]

  depends_on = [
    module.agent_keyvault_secrets_role
  ]
}