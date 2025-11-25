module "static_site" {
  source = "github.com/alrudolph/tf-utils/modules/aws/static-site/module"

  s3_bucket_name = "globally-unique-bucket-name-to-store-site-files"
  domains = [
    "my-site.com",
    "www.my-site.com",
  ]

  # This is to find your public certificate in ACM:
  certificate_domain_name = "my-site.com"
}
