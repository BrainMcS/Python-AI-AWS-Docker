terraform {
  required_providers {
	aws = {
	  source  = "hashicorp/aws"
	  version = "~> 5.0"
	}
  }
}

# Configure the AWS provider
provider "aws" {
region = var.aws_region
}

# Create VPC (if not using a pre-existing one)
# resource "aws_vpc" "main" {
# cidr_block = "10.0.0.0/16"
# tags = {
# Name = "my-vpc"
# }
# }

# # Create public subnets (at least two for high availability)
# resource "aws_subnet" "public" {
# count = 2
# vpc_id = aws_vpc.main.id
# cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
# availability_zone = data.aws_availability_zones.available.names[count.index]
# tags = {
# Name = "public-subnet-${count.index}"
# }
# }

# Create a security group for your application instances (EC2)
resource "aws_security_group" "app_sg" {
name = "allow_ssh_and_http"
description = "Allow SSH and HTTP(S) access"
vpc_id = var.vpc_id # Associate with your VPC

# Allow SSH inbound traffic (restrict CIDR as needed)
ingress {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"] # Replace with your source IP or CIDR range
            # Allow traffic to Redshift
            ingress {
                from_port       = 5439
                to_port         = 5439
                protocol        = "tcp"
                security_groups = [aws_security_group.redshift_sg.id] # Allow from Redshift SG
            } 
        }

            # Allow HTTP inbound traffic from the load balancer
            ingress {
            from_port = var.app_port # Use the application port
            to_port = var.app_port
            protocol = "tcp"
            security_groups = [aws_security_group.alb_sg.id] # Allow from ALB security group
            }

            # Allow all outbound traffic (you might want to restrict this further)
            egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
            }
}

# Create a security group for Redshift
resource "aws_security_group" "redshift_sg" {
name = "allow_redshift_access"
description = "Allow access to Redshift"
vpc_id = var.vpc_id
    ingress {
    from_port = 5439 # Default Redshift port
    to_port = 5439
    protocol = "tcp"
    security_groups = [aws_security_group.app_sg.id] # Allow access from app security
    group
    }
}

# Create Redshift cluster
resource "aws_redshift_cluster" "default" {
cluster_identifier = "my-redshift-cluster-${var.env}" # Include environment in name
database_name = "my_database"
master_username = var.redshift_master_username
master_password = var.redshift_master_password # Handle securely (Vault or
Secrets Manager)
node_type   = "dc2.large" # Choose appropriate node type
cluster_type = "single-node" # Or multi-node if needed
vpc_security_group_ids = [aws_security_group.redshift_sg.id] # Assign security group
to Redshift cluster
}

# Create security group for the ALB
resource "aws_security_group" "alb_sg" {
name = "allow_alb_access"
description = "Allow HTTP access to the ALB"
vpc_id = var.vpc_id
    ingress {
    from_port = 80 # HTTP port
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this as needed for production
    }

    egress { # Allow ALB to communicate with your application instances
    from_port = 0
    to_port = 0
    protocol = "-1" # All protocols
    security_groups = [aws_security_group.app_sg.id]
    }
}

# Create Elastic Load Balancer (ALB)
resource "aws_lb" "app_lb" {
name = "my-app-lb-${var.env}" # Include environment in name
internal = false
load_balancer_type = "application"
security_groups = [aws_security_group.alb_sg.id]
subnets = var.public_subnets
# ... other load balancer configuration (target groups, listeners, etc.)
}

# Create target group for the ALB
resource "aws_lb_target_group" "app_tg" {
name = "my-app-tg-${var.env}" # Include environment
port = var.app_port
protocol = "HTTP" # Or HTTPS if using SSL
vpc_id = var.vpc_id
target_type = "instance" # Or "ip" if needed
    health_check {
    path = "/" # Health check path
    protocol = "HTTP" # Or HTTPS
    matcher = "200" # Expected HTTP status code
    interval = 30 # Health check interval (seconds)
    healthy_threshold = 2 # Number of consecutive healthy checks
    unhealthy_threshold = 2 # Number of consecutive unhealthy checks
    }
}

# Create listener for the ALB (HTTP)
resource "aws_lb_listener" "http" {
load_balancer_arn = aws_lb.app_lb.arn
port = "80"
protocol = "HTTP"
    default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
    }
}

# EC2 Instance (or other compute resource)
resource "aws_instance" "app_server" {
ami = var.ami_id
instance_type = var.instance_type
vpc_security_group_ids = [aws_security_group.app_sg.id] # Associate with security group
iam_instance_profile = aws_iam_instance_profile.ecr_pull.name

# Count for multiple instances (if needed for scaling)
count = var.instance_count
user_data = data.template_file.user_data.rendered
    tags = {
    Name = "python-app-server-${count.index}"
    }
}

# IAM role and instance profile for EC2 to pull from ECR
resource "aws_iam_role" "ecr_pull_role" {
name = "ecr-pull-role"
assume_role_policy = data.aws_iam_policy_document.ecr_assume_role.json
}

data "aws_iam_policy_document" "ecr_assume_role" {
    statement {
    actions = ["sts:AssumeRole"]
        principals {
        type = "Service"
        identifiers = ["ec2.amazonaws.com"]
        }
    }
}

resource "aws_iam_instance_profile" "ecr_pull" {
name = "ecr-pull-profile"
role = aws_iam_role.ecr_pull_role.name
}

resource "aws_iam_role_policy_attachment" "ecr_policy_attachment" {
policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
role = aws_iam_role.ecr_pull_role.name
}

data "template_file" "user_data" {
template = file("${path.module}/app_setup.sh")
    vars = {
    # ... other variables ...
    }
}