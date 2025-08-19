# IAM Roles Module

This module creates IAM roles for the FoodTruck project with appropriate trust policies and permissions.

## Resources Created

- **Admin Role**: Full administrative access for human users
- **GitHub Actions Role**: Limited permissions for CI/CD automation
- **Custom Policy**: Restricted policy for GitHub Actions (S3 sync + EC2 access)

## Usage

```hcl
module "iam_roles" {
  source = "./modules/iam-roles"
  
  admin_role_name           = "FoodruckAdmin"
  github_actions_role_name  = "FoodruckGithubActions"
  account_id               = data.aws_caller_identity.current.account_id
  github_actions_role_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/github-actions-role"
  
  tags = {
    Project     = "FoodTruck"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin_role_name | Name for the admin IAM role | `string` | `"FoodruckFull"` | no |
| github_actions_role_name | Name for the GitHub Actions IAM role | `string` | `"FoodruckGithubActions"` | no |
| account_id | AWS Account ID for role trust policies | `string` | n/a | yes |
| github_actions_role_arn | ARN of the GitHub Actions role | `string` | `null` | no |
| tags | Tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| admin_role_arn | ARN of the admin IAM role |
| admin_role_name | Name of the admin IAM role |
| github_actions_role_arn | ARN of the GitHub Actions IAM role |
| github_actions_role_name | Name of the GitHub Actions IAM role |
| github_actions_policy_arn | ARN of the GitHub Actions custom policy |
| account_id | AWS Account ID |

## GitHub Actions Permissions

The GitHub Actions role has limited permissions:

- **S3**: Full access for sync operations
- **EC2**: Full access for instance management
- **SSM**: Command execution and session management
- **IAM**: PassRole for EC2 instances

This follows the principle of least privilege while enabling deployment automation.
