variable "region" {
  type        = string
  description = "The region to deploy resources"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  description = "cidr block for vpc"
  default     = "10.255.0.0/20"
}

variable "default_tag" {
  type        = map(string)
  description = "map of default tags to apply to resources"
  default = {
    "Project" = "REDACRE"
  }
}
variable "public_subnet_count" {
  type        = number
  description = "number of public subnets"
  default     = 2
}
variable "private_subnet_count" {
  type        = number
  description = "number of public subnets"
  default     = 2
}
