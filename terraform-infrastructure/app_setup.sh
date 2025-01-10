#!/bin/bash
set -e

# Install Docker (if not already present)
if ! command -v docker &> /dev/null; then

# Install Docker (adapt for your OS)
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user # Add ec2-user to docker group
newgrp docker # Refresh docker group membership for current shell
fi

# Authenticate with ECR
aws ecr get-login-password --region ${aws_region} | docker login --username AWS
--password-stdin <aws_account_id>.dkr.ecr.${aws_region}.amazonaws.com

# Pull the Docker image from ECR
docker pull ${ecr_repo_url}:latest

# Run the Docker container
docker run -d -p ${app_port}:8080 ${ecr_repo_url}:latest # Map ports and other options
as needed

# Retrieve Redshift credentials securely (example using AWS Secrets Manager)
REDSHIFT_SECRET_ARN=$(aws secretsmanager describe-secret --secret-id
redshift-credentials --query ARN --output text) # Replace with your secret ARN
REDSHIFT_CREDS=$(aws secretsmanager get-secret-value --secret-id
"$REDSHIFT_SECRET_ARN" --query SecretString --output text | jq -r '.host,
.username, .password, .dbname') # Assumes your secret stores these values
REDSHIFT_HOST=$(echo "$REDSHIFT_CREDS" | cut -d',' -f1)
REDSHIFT_USERNAME=$(echo "$REDSHIFT_CREDS" | cut -d',' -f2)
REDSHIFT_PASSWORD=$(echo "$REDSHIFT_CREDS" | cut -d',' -f3)
REDSHIFT_DB_NAME=$(echo "$REDSHIFT_CREDS" | cut -d',' -f4)

# Set environment variables for your application
export REDSHIFT_HOST=$REDSHIFT_HOST
export REDSHIFT_USERNAME=$REDSHIFT_USERNAME
export REDSHIFT_PASSWORD=$REDSHIFT_PASSWORD
export REDSHIFT_DB_NAME=$REDSHIFT_DB_NAME

# Retrieve Datadog API key (ensure the instance has permissions to access Secrets Manager)
DD_API_KEY=$(aws secretsmanager get-secret-value --secret-id
datadog-api-key-${var.env} --query SecretString --output text)

# Install and configure the Datadog Agent (replace with your actual process)
DD_API_KEY="${DD_API_KEY}" bash -c "$(curl -L
https://raw.githubusercontent.com/DataDog/datadog-agent/master/cmd/agent/agent-inst
all.sh)"