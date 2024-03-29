output "id" {
  value       = aws_cloudfront_distribution.this.id
  description = "CDN distribution ID."
}

output "arn" {
  value       = aws_cloudfront_distribution.this.arn
  description = "CDN distribution ARN."
}

output "domain_name" {
  value       = aws_cloudfront_distribution.this.domain_name
  description = "CDN distribution's domain name."
}

output "hosted_zone_id" {
  value       = aws_cloudfront_distribution.this.hosted_zone_id
  description = "CDN Route 53 zone ID."
}

output "oai_iam_arn" {
  value       = aws_cloudfront_origin_access_identity.this.iam_arn
  description = "Origin Access Identity pre-generated ARN that can be used in S3 bucket policies."
}

output "deployment_policy_id" {
  value       = aws_iam_policy.deployment_policy.arn
  description = "IAM policy for deploying CloudFront distribution."
}

output "origin_path" {
  value       = local.origin_path
  description = "Origin path"
}

output "deployment_group" {
  value       = aws_iam_group.deployment.name
  description = "Deployment group name"
}

output "deployment_group_arn" {
  value       = aws_iam_group.deployment.arn
  description = "Deployment group ARN"
}
