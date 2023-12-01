variable "instance" {
  description = "describes sql server related configuration"
  type        = any
}

variable "naming" {
  description = "used for naming purposes"
  type        = map(string)
}
