data "aws_caller_identity" "current" {}

data "aws_iam_policy" "administrator_access" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]

  tags = var.tags
}

resource "aws_iam_role" "admin_role" {
  name               = "FoodTruckFull"
  assume_role_policy = data.aws_iam_policy_document.admin_trust_policy.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "admin_role_policy" {
  role       = aws_iam_role.admin_role.name
  policy_arn = data.aws_iam_policy.administrator_access.arn
}

# GitHub Actions Role with OIDC trust policy
resource "aws_iam_role" "github_actions_role" {
  name               = "FoodTruckGithubActions"
  assume_role_policy = data.aws_iam_policy_document.github_actions_trust_policy.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "github_actions_role_policy" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_actions_policy.arn
}
