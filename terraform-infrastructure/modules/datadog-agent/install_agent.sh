#!/bin/bash
set -e # Exit on any error

# Retrieve Datadog API key from Secrets Manager
DD_API_KEY=$(aws secretsmanager get-secret-value --secret-id "${datadog_api_key_arn}" --query SecretString --output text)

# Install Datadog Agent
DD_API_KEY="${DD_API_KEY}" bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/datadog-agent/master/cmd/agent/agent-install.sh)"