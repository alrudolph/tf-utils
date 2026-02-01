terraform {
  required_providers {
    aws = {
      source  = "aws"
      version = "~> 5.33.0"
    }
    namecheap = {
      source  = "namecheap/namecheap"
      version = ">= 2.0.0"
    }
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = concat(
    [var.domain_name],
    var.alternative_names
  )
}

resource "namecheap_domain_records" "example" {
  domain = var.domain_name

  dynamic "record" {
    for_each = aws_acm_certificate.cert.domain_validation_options
    content {
      hostname = replace(
        record.value.resource_record_name,
        ".${var.domain_name}.",
        ""
      )

      # type  = record.value.resource_record_type
      type    = "CNAME"
      address = record.value.resource_record_value
      ttl     = 300
    }
  }
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.cert.arn

  validation_record_fqdns = [
    for dvo in aws_acm_certificate.cert.domain_validation_options :
    dvo.resource_record_name
  ]

  depends_on = [namecheap_domain_records.example]
}
