resource "aws_instance" "datadog_agent" {
ami = var.ami_id
instance_type = var.instance_type
vpc_security_group_ids = [aws_security_group.datadog_sg.id]
iam_instance_profile = aws_iam_instance_profile.datadog.name
count = var.instance_count
user_data = templatefile("${path.module}/install_agent.sh",
{
datadog_api_key_arn = var.datadog_api_key_arn
}
)
tags = {
    Name = "datadog-agent-${count.index}"
}
lifecycle {
create_before_destroy = true # Replace instances one at a time during updates
}
}

# Datadog Security Group
# Open only necessary ports (restrict as much as possible)
resource "aws_security_group" "datadog_sg" {
name = "datadog-agent-sg"
description = "Security group for Datadog agent"
vpc_id = var.vpc_id
ingress {
from_port = 443 # HTTPS for communication with Datadog
to_port = 443
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"] # Restrict this in production
}
ingress {
from_port = 80 # Optional: for status checks and other HTTP traffic
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"] # Restrict this in production
}
egress { # Allow all outbound traffic (consider restricting this further)
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
}

# IAM role for Datadog Agent (least privilege)
resource "aws_iam_role" "datadog" {
name = "datadog-agent-role"
assume_role_policy = jsonencode({
Version = "2012-10-17",
Statement = [
{
Action = "sts:AssumeRole",
Effect = "Allow",
Principal = {
Service = "ec2.amazonaws.com"
}
}
]
})
}

# Attach necessary policies (least privilege)
# Secrets Manager access to retrieve the API key
resource "aws_iam_role_policy_attachment" "datadog_secrets_manager_access" {
policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite" # Restrict further
based on your needs
role = aws_iam_role.datadog.name
}

# Attach the instance profile to the role
resource "aws_iam_instance_profile" "datadog" {
name = "datadog-agent-profile"
role = aws_iam_role.datadog.name
}