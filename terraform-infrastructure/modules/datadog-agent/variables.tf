variable "ami_id" {
type = string
description = "AMI ID for the Datadog Agent instances."
}

variable "instance_type" {
type = string
description = "Instance type for the Datadog Agent instances."
}

variable "instance_count" {
type = number
default = 1
}

variable "datadog_api_key_arn" {
type = string
description = "ARN of the Datadog API key in Secrets Manager."
sensitive = true
}

variable "vpc_id" {
type = string
description = "The ID of the VPC."
}

# modules/datadog-agent/install_agent.sh
#!/bin/bash
set -e # Exit on any error

# Retrieve Datadog API key from Secrets Manager
DD_API_KEY=$(aws secretsmanager get-secret-value --secret-id
"${datadog_api_key_arn}" --query SecretString --output text)

# Install Datadog Agent
DD_API_KEY="${DD_API_KEY}" bash -c "$(curl -L
https://raw.githubusercontent.com/DataDog/datadog-agent/master/cmd/agent/agent-inst
all.sh)"