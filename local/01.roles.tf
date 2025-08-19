data "aws_caller_identity" "current" {}

module "iam_roles" {
  source = "../modules/iam"
  
  admin_role_name          = "FoodTruckFull"
  github_actions_role_name = "FoodTruckGithubActions"
  account_id              = data.aws_caller_identity.current.account_id
  github_actions_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/github-actions-role"
  
  tags = {
    Project     = "FoodTruck"
    Environment = "Local"
    ManagedBy   = "Terraform"
  }
}
