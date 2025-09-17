variable "aws_region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "ap-southeast-1"
}

variable "ssh_key_name" {
  description = "The name of the SSH key pair to use for instances"
  type        = string
  default     = "vedantkey"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of AZs to create subnets in"
  type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "node_desired_size" {
  type    = number
  default = 3
}
variable "node_min_size" {
  type    = number
  default = 3
}
variable "node_max_size" {
  type    = number
  default = 3
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.small"]
}
