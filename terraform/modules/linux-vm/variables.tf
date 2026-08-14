variable "vm_name" {}

variable "location" {}

variable "resource_group_name" {}

variable "subnet_id" {}

variable "vm_size" {}

variable "admin_username" {}

variable "public_key" {}

variable "allowed_ssh_ip" {}

variable "tags" {
  description = "Tags applied to the VM resources"
  type        = map(string)
  default     = {}
}

variable "identity_ids" {
  type    = list(string)
  default = []
}