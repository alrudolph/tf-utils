# Static Site Hosting Module

## What it does

Creates a CloudFront distribution backed by a private S3 bucket for hosting static websites. The S3 bucket stores your site files and CloudFront serves them globally with caching.

## Why it's useful

Setting up CloudFront with S3 requires configuring several interconnected resources: origin access control, bucket policies, cache behaviors, and SSL certificates. This module handles the boilerplate configuration so you can deploy a static site with a few variables.

The setup uses modern AWS best practices:
- Private S3 bucket (not public)
- CloudFront Origin Access Control (OAC) instead of the legacy Origin Access Identity
- Automatic HTTPS redirect
- Optional custom domain support with ACM certificates

## Usage

```hcl
module "static_site" {
  source = "github.com/alrudolph/tf-utils/modules/aws/static-site/module"

  s3_bucket_name = "globally-unique-bucket-name"

  # Optional: Custom domains
  domains = [
    "example.com",
    "www.example.com",
  ]

  # Required if using custom domains
  certificate_domain_name = "example.com"
}
```

## Variables

- `s3_bucket_name` (required) - Globally unique name for the S3 bucket that will store your site files
- `domains` (optional) - List of custom domain names to associate with the distribution
- `certificate_domain_name` (optional) - Domain name for looking up the ACM certificate. Required if using custom domains. The certificate must already exist in ACM and be in the `us-east-1` region (CloudFront requirement).

## Important notes

- After deployment, upload your static files to the S3 bucket
- Default behavior serves `index.html` as the root document
- Error pages default to `error.html`
- Price class is set to `PriceClass_100` (North America and Europe only) to minimize costs
- Default cache TTL is 1 hour (3600 seconds)
- If using custom domains, the ACM certificate must be in `us-east-1` regardless of where your other resources are
- You need to manually create DNS records pointing your domains to the CloudFront distribution
