output "admin_role_arn" {
  description = "ARN of the admin IAM role"
  value       = aws_iam_role.admin_role.arn
}

output "github_actions_role_arn" {
  description = "ARN of the GitHub Actions IAM role (null if not created)"
  value       = length(aws_iam_role.github_actions_role) > 0 ? aws_iam_role.github_actions_role[0].arn : null
}
