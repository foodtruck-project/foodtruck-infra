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

  statement {
    effect = "Allow"
    actions = [
      "ec2:*"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = ["iam:PassRole"]
    resources = ["arn:aws:iam::${var.account_id}:role/*"]
  }
}

data "aws_iam_policy_document" "admin_trust_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:root"]
    }
  }
}

data "aws_iam_policy_document" "github_actions_trust_policy" {
  count = var.github_actions_role_arn != null ? 1 : 0
  
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [var.github_actions_role_arn]
    }
  }
}

resource "aws_iam_policy" "github_actions_policy" {
  name        = "${var.github_actions_role_name}Policy"
  description = "Limited permissions for GitHub Actions: S3 sync and EC2 root access"
  policy      = data.aws_iam_policy_document.github_actions_policy.json
  tags        = var.tags
}

resource "aws_iam_role" "admin_role" {
  name               = var.admin_role_name
  assume_role_policy = data.aws_iam_policy_document.admin_trust_policy.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "admin_role_policy" {
  role       = aws_iam_role.admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role" "github_actions_role" {
  count              = var.github_actions_role_arn != null ? 1 : 0
  name               = var.github_actions_role_name
  assume_role_policy = data.aws_iam_policy_document.github_actions_trust_policy[0].json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "github_actions_role_policy" {
  count      = var.github_actions_role_arn != null ? 1 : 0
  role       = aws_iam_role.github_actions_role[0].name
  policy_arn = aws_iam_policy.github_actions_policy.arn
}
