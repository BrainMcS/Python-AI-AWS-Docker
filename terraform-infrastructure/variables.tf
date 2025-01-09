variable "aws_region" {
type = string
description = "The AWS region to deploy resources in."
}
variable "vpc_id" {
type = string
description = "ID of the VPC"
}
variable "public_subnets" {
type = list(string)
description = "List of public subnet IDs"
}
variable "ami_id" {
type = string
description = "The AMI ID for the EC2 instances."
}
variable "instance_type" {
type = string
description = "The instance type for the EC2 instances."
}
variable "instance_count" {
type = number
description = "The number of EC2 instances to launch."
default = 1
}
variable "app_port" {
type = number
description = "The port your application listens on."
default = 8080
}
variable "redshift_master_username" {
type = string
description = "The master username for the Redshift cluster."
sensitive = true # Mark as sensitive
}
variable "redshift_master_password" {
type = string
description = "The master password for the Redshift cluster."
sensitive = true # Mark as sensitive
}
variable "env" {
type = string
description = "T arget environment (e.g., dev, prod)"
}
variable "kms_key_id" {
type = string
description = "KMS Key for encrypting secrets"
}
variable "vault_address" {
type = string
description = "Address of Vault Server"
}
variable "vault_secret_path" {
type = string
description = "Path to the Datadog API key in Vault"
default = "common/datadog"
}
variable "vault_role" {
type = string
description = "Vault role to authenticate with"
}
variable "redshift_secret_arn" {
type = string
description = "ARN of the secret storing Redshift credentials"
sensitive = true
}