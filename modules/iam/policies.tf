data "aws_iam_policy_document" "admin_trust_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

data "aws_iam_policy_document" "github_actions_trust_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:foodtruck-project/infra:*"]
    }
  }
}

data "aws_iam_policy_document" "github_actions_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetObjectVersion",
      "s3:PutObjectAcl",
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets"
    ]
    resources = [
      "arn:aws:s3:::*",
      "arn:aws:s3:::*/*"
    ]
  }

  # EC2 permissions for instance management
  statement {
    effect = "Allow"
    actions = [
      "ec2:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "github_actions_policy" {
  name        = "FoodTruckGithubActionsPolicy"
  description = "Limited permissions for GitHub Actions: S3 sync and EC2 root access"
  policy      = data.aws_iam_policy_document.github_actions_policy.json
  tags        = var.tags
}
