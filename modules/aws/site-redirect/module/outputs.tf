output "cloudfront_url" {
    description = "The default domain name (URL) of the CloudFront distribution"
    value       = aws_cloudfront_distribution.redirect_site_cloudfront.domain_name
}
