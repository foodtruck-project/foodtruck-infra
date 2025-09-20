resource "aws_s3_bucket" "foodtruck_website_bucket" {
  bucket = "foodtruck-website-live"

  tags = {
    Name        = "FoodTruck Website"
    Environment = "FoodTruckLive"
  }
}

resource "aws_s3_bucket_website_configuration" "foodtruck_website" {
  bucket = aws_s3_bucket.foodtruck_website_bucket.id

  index_document {
    suffix = "index.html"
  }
}

locals {
  mime_types = {
    ".html" = "text/html"
    ".webp" = "image/webp"
    ".css"  = "text/css"
    ".js"   = "application/javascript"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".svg"  = "image/svg+xml"
    ".gif"  = "image/gif"
    ".ico"  = "image/x-icon"
    ".json" = "application/json"
    ".txt"  = "text/plain"
  }
}

locals {
  website_files_filtered = [
    for file in fileset("${path.module}/foodtruck-website", "**") :
    file if startswith(file, "public/") || startswith(file, "assets/") || startswith(file, "index.html")
  ]
}

resource "aws_s3_object" "website_files" {
  for_each = { for f in local.website_files_filtered : f => f }

  bucket       = aws_s3_bucket.foodtruck_website_bucket.id
  key          = each.value
  source       = "${path.module}/foodtruck-website/${each.value}"
  etag         = filemd5("${path.module}/foodtruck-website/${each.value}")
  content_type = length(regexall("\\.[^.]+$", each.value)) > 0 ? lookup(local.mime_types, regex("\\.[^.]+$", each.value), "application/octet-stream") : "application/octet-stream"
}

resource "aws_s3_bucket_ownership_controls" "foodtruck_website_ownership" {
  bucket = aws_s3_bucket.foodtruck_website_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "foodtruck_website_access_block" {
  bucket = aws_s3_bucket.foodtruck_website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "iam-policy-1" {
  statement {
    sid    = "AllowPublicRead"
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.foodtruck_website_bucket.arn}",
      "${aws_s3_bucket.foodtruck_website_bucket.arn}/*",
    ]
    actions = ["S3:GetObject"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "foodtruck_website_public_policy" {
  bucket = aws_s3_bucket.foodtruck_website_bucket.id
  policy = data.aws_iam_policy_document.iam-policy-1.json
}
