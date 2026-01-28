variable "s3_bucket_name" {
  type        = string
  description = "S3 Bucket Name"
}

variable "domains" {
  type        = list(string)
  description = "Domain names to associate with the CloudFront distribution"
  default     = null
}

variable "certificate_domain_name" {
  type        = string
  description = "Primary domain name used for ACM certificate"
  default     = null
}

variable "redirect_domain" {
  type        = string
  description = "Domain to redirect to"
}
