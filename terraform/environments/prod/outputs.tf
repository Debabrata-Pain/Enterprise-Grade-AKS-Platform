output "agent_vm_public_ip" {
  value = module.azure_devops_agent.public_ip
}

output "enterprise_flask_workload_identity_client_id" {
  value = module.enterprise_flask_identity.client_id
}