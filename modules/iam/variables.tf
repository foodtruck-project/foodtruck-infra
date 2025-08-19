variable "admin_role_name" {
  description = "Name for the admin IAM role"
  type        = string
  default     = "FoodruckFull"
}

variable "github_actions_role_name" {
  description = "Name for the GitHub Actions IAM role"
  type        = string
  default     = "FoodruckGithubActions"
}

variable "github_actions_role_arn" {
  description = "ARN of the GitHub Actions role that can assume the deployment role"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "account_id" {
  description = "AWS Account ID for role trust policies"
  type        = string
}