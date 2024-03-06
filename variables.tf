variable "instance" {
  description = "describes sql server related configuration"
  type        = any
}

variable "naming" {
  description = "used for naming purposes"
  type        = map(string)
}

variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resourcegroup" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
