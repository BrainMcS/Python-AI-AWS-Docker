aws_region = "us-west-2" # Replace with your dev region
vpc_id = "vpc-xxxxxxxxxxxxxxxxx" # Dev VPC ID
public_subnets = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-yyyyyyyyyyyyyyyyy"] # Dev
public subnets
ami_id = "ami-xxxxxxxxxxxxxxxxx" # AMI for dev instances
instance_type = "t2.micro" # Instance type for dev
redshift_master_username = "devuser" # Dev Redshift username
redshift_master_password = "devpassword" # Handle securely (Vault or Secrets
Manager)
env = "dev"
datadog_api_key_arn =
"arn:aws:secretsmanager:us-west-2:xxxxxxxxxxxx:secret:datadog-api-key-dev-abcdef"
# Dev Datadog API key ARN
instance_count = 1
vault_address = "https://your-vault-address.com"
vault_secret_path = "path/to/your/dev/secret" # Update if needed
vault_role = "dev-terraform-role" # Dev Vault authentication role
kms_key_id =
"arn:aws:kms:us-west-2:xxxxxxxxxxxx:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" #
Dev KMS key ARN
app_port = 8080