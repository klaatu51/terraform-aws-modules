variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type = list(string)
  default = ["10.1.0.0/28", "10.2.0.0/28", "10.3.0.0/28"]
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type = list(string)
  default = ["10.4.0.0/24", "10.5.0.0/24", "10.6.0.0/24"]
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}