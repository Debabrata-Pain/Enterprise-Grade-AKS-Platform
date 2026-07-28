variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "identity_id" {
  type = string
}


variable "system_subnet_id" {
  type = string
}

variable "user_subnet_id" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "system_node_count" {
  type    = number
  default = 2
}

variable "system_vm_size" {
  type    = string
  default = "Standard_DS2_v2"
}

variable "tags" {
  type = map(string)
}

variable "system_node_min_count" {
  default = 2
}

variable "system_node_max_count" {
  default = 5
}