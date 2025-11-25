# GitHub Actions AWS Access Module

## What it does

Sets up OIDC authentication for GitHub Actions to access AWS resources. Creates an IAM role that GitHub Actions workflows can assume without storing long-lived AWS credentials.

## Why it's useful

Traditional approaches require storing AWS access keys as GitHub secrets, which poses security risks:
- Keys can be accidentally logged or exposed
- Keys don't automatically rotate
- Keys have broad permissions that persist even when not in use

OIDC authentication is more secure because GitHub Actions receives temporary credentials that only work during workflow execution. AWS trusts GitHub's identity provider to verify which repository is making requests.

## Usage

```hcl
module "gh_actions_perms" {
  source = "github.com/alrudolph/tf-utils/modules/aws/gh-actions-access/module"

  github_repo = "owner/repository-name"
  role_name   = "my-github-actions-role"

  role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "cloudfront:*",
        ]
        Resource = "*"
      }
    ]
  })
}
```

In your GitHub Actions workflow:

```yaml
permissions:
  id-token: write
  contents: read

steps:
  - name: Configure AWS credentials
    uses: aws-actions/configure-aws-credentials@v4
    with:
      role-to-assume: arn:aws:iam::ACCOUNT_ID:role/my-github-actions-role
      aws-region: us-east-1

  - name: Deploy to S3
    run: aws s3 sync ./build s3://my-bucket
```

## Variables

- `github_repo` (required) - Repository in format `owner/repo-name` (e.g., `octocat/hello-world`)
- `role_name` (required) - Name for the IAM role that will be created
- `role_policy` (required) - JSON-encoded IAM policy defining what AWS actions the role can perform

## Important notes

- The role trusts the entire repository (all branches, PRs, and tags). The condition uses `repo:owner/repo:*` to allow any workflow in that repository.
- GitHub's OIDC thumbprints are hardcoded in the module. These rarely change but may need updating if GitHub rotates their certificates.
- Your workflow must request the `id-token: write` permission to get OIDC tokens.
- The `role_policy` should follow the principle of least privilege. Grant only the permissions needed for your workflows.
- If you need different permissions for different workflows, create multiple instances of this module with different role names and policies.
