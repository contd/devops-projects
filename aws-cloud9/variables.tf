variable "aws_region" {
 type = "string"
 description = "Used AWS Region."
}

variable "environment" {
  type = "string"
  description = "Production or Development setting"
}
variable "name" {
  description = "The name of the environment"
}

variable "instance_type" {
  description = "The type of instance to connect to the environment"
  default     = "t2.nano"
}

variable "automatic_stop_time_minutes" {
  description = "Minutes until the instance is shut down after inactivity"
  default     = 30
}

variable "description" {
  description = "The description of the environment"
}
