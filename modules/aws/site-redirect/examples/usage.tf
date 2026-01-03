module "site_redirect" {
  source = "github.com/alrudolph/tf-utils/modules/aws/site-redirect/module"

  s3_bucket_name = "globally-unique-bucket-name-placeholder"
  domains = [
    "alternative-domain.com",
    "www.alternative-domain.com",
  ]

  certificate_domain_name = "alternative-domain.com"
  redirect_domain = "my-site.com"
}
