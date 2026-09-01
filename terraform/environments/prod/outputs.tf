output "agent_vm_public_ip" {
  value = module.azure_devops_agent.public_ip
}

output "enterprise_flask_workload_identity_client_id" {
  description = "Client ID of the Enterprise Flask workload identity"
  value       = module.enterprise_flask_identity.client_id
}