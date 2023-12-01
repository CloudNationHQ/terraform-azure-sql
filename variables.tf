variable "sql" {
  description = "Contains all sql settings"
  type        = any
}

variable "naming" {
  description = "Used for naming purposes"
  type        = map(string)
}
