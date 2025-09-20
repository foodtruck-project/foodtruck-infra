output "bucket_name" {
  description = "The name of the created bucket"
  value       = aws_s3_bucket.foodtruck_website_bucket.id
}

output "bucket_url" {
  description = "The URL of the created bucket"
  value       = aws_s3_bucket.foodtruck_website_bucket.bucket_regional_domain_name
}

output "bucket_arn" {
  description = "The ARN of the created bucket"
  value       = aws_s3_bucket.foodtruck_website_bucket.arn
}
