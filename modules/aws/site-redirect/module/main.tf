terraform {
  required_providers {
    aws = {
      source  = "aws"
      version = "~> 5.33.0"
    }
  }
}

# ################# #
# Private S3 Bucket #
# ################# #

resource "aws_s3_bucket" "redirect_site_bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_policy" "redirect_site_bucket_policy" {
  bucket = aws_s3_bucket.redirect_site_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "AllowGetObjects"
    Statement = [
      {
        Sid    = "AllowCloudfront"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.redirect_site_bucket.arn}/**"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.redirect_site_cloudfront.arn
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "redirect_site_cloudfront_config" {
  bucket = aws_s3_bucket.redirect_site_bucket.bucket

  redirect_all_requests_to {
    host_name = var.redirect_domain
  }
}

# ####################### #
# CloudFront Distribution #
# ####################### #

resource "aws_cloudfront_distribution" "redirect_site_cloudfront" {
  enabled         = true
  is_ipv6_enabled = true

  origin {
    origin_id   = "${aws_s3_bucket.redirect_site_bucket.bucket}-origin"
    domain_name = "${aws_s3_bucket.redirect_site_bucket.bucket}.s3-website-${aws_s3_bucket.redirect_site_bucket.region}.amazonaws.com"

    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  aliases = var.domains != null ? var.domains : []

  default_cache_behavior {
    target_origin_id = "${aws_s3_bucket.redirect_site_bucket.bucket}-origin"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.domains == null ? true : null
    acm_certificate_arn            = var.certificate_domain_name != null ? data.aws_acm_certificate.domain_certificate[0].arn : null
    ssl_support_method             = var.domains != null ? "sni-only" : null
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  price_class = "PriceClass_100"
}

data "aws_acm_certificate" "domain_certificate" {
  count    = var.certificate_domain_name != null ? 1 : 0
  domain   = var.certificate_domain_name
  statuses = ["ISSUED"]
}
