terraform {
  required_providers {
    aws = {
      source  = "aws"
      version = "~> 5.33.0"
    }
  }
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
}

resource "aws_iam_role" "github_actions" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      for it in coalesce(var.github_repos, [var.github_repo]) :
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          },
          StringLike = {
            "token.actions.githubusercontent.com:sub" : "repo:${it}:*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "terraform_permissions" {
  count = var.role_policy != null ? 1 : 0
  name   = "terraform-access-policy"
  role   = aws_iam_role.github_actions.id
  policy = var.role_policy
}
