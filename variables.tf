# Declare your variables as before
variable "ami_id" {
  description = "The AMI to use for the compute instances"
}

variable "instance_type" {
  description = "The type of instance to start"
}

variable "key_name" {
  description = "The key name to use for the instance"
}

variable "subnet_id" {
  description = "The ID of the subnet"
}

variable "security_group_id" {
  description = "The ID of the security group"
}

variable "instance_count" {
  description = "Number of instances to launch"
  default     = 2
}
