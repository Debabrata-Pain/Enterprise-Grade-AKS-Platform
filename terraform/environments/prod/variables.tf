variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "environment" {
  description = "Environment Name"
  type        = string
}

variable "ado_acr_service_principal_object_id" {
  description = "Object ID of the service principal used by the Azure DevOps ACR service connection"
  type        = string
}