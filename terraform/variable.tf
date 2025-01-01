variable "subnet_count" {
  description = "Number of subnets to create"
  type        = number
  default     = 2
}

variable "subnet_tags" {
  description = "Tags to apply to the subnets"
  type        = map(string)
  default     = {
    Name = "main-subnet"
  }
}