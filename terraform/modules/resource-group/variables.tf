variable "name" {

  description = "Resource Group Name"

  type = string

}

variable "location" {

  description = "Azure Region"

  type = string

}

variable "tags" {

  description = "Tags"

  type = map(string)

  default = {}

}