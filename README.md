# tf-utils

Collection of Terraform modules for AWS infrastructure. These modules handle common setup patterns that involve multiple interconnected resources.

## Available Modules

### Static Site Hosting

Creates a CloudFront distribution backed by a private S3 bucket for hosting static websites with optional custom domain support.

```terraform
module "static_site" {
  source = "github.com/alrudolph/tf-utils/modules/aws/static-site/module"

  s3_bucket_name          = "my-site-bucket"
  domains                 = ["example.com", "www.example.com"]
  certificate_domain_name = "example.com"
}
```

[Full documentation](modules/aws/static-site/README.md)

### S3 Backend

Creates S3 bucket and DynamoDB table for Terraform remote state storage and locking.

```terraform
module "s3_backing" {
  source = "github.com/alrudolph/tf-utils/modules/aws/s3-backing/module"

  bucket_name = "my-terraform-state-bucket"
  table_name  = "my-terraform-state-lock"
}
```

[Full documentation](modules/aws/s3-backing/README.md)

### GitHub Actions AWS Access

Sets up OIDC authentication for GitHub Actions to access AWS without storing long-lived credentials.

```terraform
module "gh_actions_perms" {
  source = "github.com/alrudolph/tf-utils/modules/aws/gh-actions-access/module"

  github_repo = "owner/repo-name"
  role_name   = "my-github-actions-role"
  role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:*"]
        Resource = "*"
      }
    ]
  })
}
```

[Full documentation](modules/aws/gh-actions-access/README.md)

## Usage

Reference modules directly from GitHub:

```terraform
module "example" {
  source = "github.com/alrudolph/tf-utils/modules/aws/<module-name>/module"
  # ... variables
}
```

Or clone the repository and use local paths:

```terraform
module "example" {
  source = "./tf-utils/modules/aws/<module-name>/module"
  # ... variables
}
```

## Requirements

- Terraform >= 1.0
- AWS Provider ~> 5.33.0

## Structure

```
modules/
└── aws/
    ├── static-site/
    │   ├── module/       # Module source
    │   └── examples/     # Usage examples
    ├── s3-backing/
    │   ├── module/
    │   └── examples/
    └── gh-actions-access/
        ├── module/
        └── examples/
```

Each module includes example usage files in its `examples/` directory.
