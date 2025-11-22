output "public_url" {
  value = "https://${aws_cloudfront_distribution.staticweb.domain_name}"
}
