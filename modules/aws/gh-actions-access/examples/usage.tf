module "gh_actions_perms" {
  source = "github.com/alrudolph/tf-utils/modules/aws/gh-actions-access/module"

  github_repo = "alrudolph/tf-utils"
  role_name   = "my-repo-gh-actions-access-role"
  role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "dynamodb:*",
          "kms:*",
          "iam:*",
        ]
        Resource = "*"
      }
    ]
  })
}
