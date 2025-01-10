output "alb_dns_name" {
  value       = aws_lb.app_lb.dns_name
  description = "The DNS name of the Application Load Balancer."
}

output "redshift_endpoint" {
  value       = aws_redshift_cluster.default.endpoint
  description = "The endpoint of the Redshift cluster."
}

output "ecr_repository_url" {
  value       = aws_ecr_repository.app_repo.repository_url
  description = "The URL of the ECR repository."
}

output "datadog_api_key_arn" {
  value       = aws_secretsmanager_secret.datadog_api_key.arn
  description = "The ARN of the Datadog API key in AWS Secrets Manager."
  sensitive   = true # Mark as sensitive to protect the ARN in logs
}