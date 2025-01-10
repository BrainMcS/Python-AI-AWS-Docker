variable "ami_id" {
  type        = string
  description = "AMI ID for the Datadog Agent instances."
}

variable "instance_type" {
  type        = string
  description = "Instance type for the Datadog Agent instances."
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "datadog_api_key_arn" {
  type        = string
  description = "ARN of the Datadog API key in Secrets Manager."
  sensitive   = true
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC."
}