aws_region = "us-east-1" # Replace with your prod region
vpc_id = "vpc-aaaaaaaaaaaaaaaaa" # Prod VPC ID
public_subnets = ["subnet-aaaaaaaaaaaaaaaaa", "subnet-bbbbbbbbbbbbbbbbb"] #
Prod public subnets
ami_id = "ami-yyyyyyyyyyyyyyyyy" # AMI for prod instances (likely different from dev)
instance_type = "t3.medium" # Instance type for prod (likely larger than dev)
redshift_master_username = "produser" # Prod Redshift username
redshift_master_password = "prodpassword" # Handle securely (Vault or Secrets
Manager)
env = "prod"
datadog_api_key_arn =
"arn:aws:secretsmanager:us-east-1:yyyyyyyyyyyy:secret:datadog-api-key-prod-ghijkl" #
Prod Datadog API key ARN
instance_count = 2 # You might have more instances in production
vault_address = "https://your-vault-address.com" # Update if different for prod
vault_secret_path = "path/to/your/prod/secret" # Update if needed
vault_role = "prod-terraform-role" # Production Vault authentication role
kms_key_id =
"arn:aws:kms:us-east-1:yyyyyyyyyyyy:key/yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy" #
Prod KMS key ARN
app_port = 8080