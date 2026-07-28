variable "deploy_firewall" {
  description = "Deploy Azure Firewall"
  type        = bool
  default     = false
}

variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "firewall_policy_id" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {}
}