locals {
  origin_id = "main"

  tags = merge({
    "terraform.module"    = "Selleo/terraform-aws-cloudfront"
    "terraform.submodule" = "public-storage"
    "context.namespace"   = var.context.namespace
    "context.stage"       = var.context.stage
    "context.name"        = var.context.name
  }, var.tags)
}

resource "random_id" "prefix" {
  byte_length = 4
}

resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "cdn-public-storage-${random_id.prefix.hex}"
  description                       = "Public Storage ${random_id.prefix.hex}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  comment             = "Public Storage ${random_id.prefix.hex}"
  enabled             = true
  is_ipv6_enabled     = true
  aliases             = var.aliases
  price_class         = var.price_class

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.certificate_arn
    minimum_protocol_version       = var.certificate_minimum_protocol_version

    # sni-only is preferred, vip causes CloudFront to use a dedicated IP address and may incur extra charges.
    ssl_support_method = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  origin {
    # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distribution-origin.html
    domain_name              = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id                = local.origin_id # must be unique within distribution
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  default_cache_behavior {
    allowed_methods  = var.default_cache_behavior.allowed_methods
    cached_methods   = var.default_cache_behavior.cached_methods
    target_origin_id = local.origin_id

    response_headers_policy_id = var.response_headers_policy_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    compress               = var.default_cache_behavior.compress
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = var.default_cache_behavior.min_ttl
    default_ttl            = var.default_cache_behavior.default_ttl
    max_ttl                = var.default_cache_behavior.max_ttl
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_responses

    content {
      error_code            = custom_error_response.value.error_code
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
    }
  }

  tags = merge(local.tags, { "resource.group" = "network" })
}

resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "Public Storage ${random_id.prefix.hex}"
}

resource "aws_iam_policy" "deployment_policy" {
  name   = "cdn-deployment-public-storage-${random_id.prefix.hex}"
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  version = "2012-10-17"

  statement {
    sid = 1

    actions = [
      "cloudfront:CreateInvalidation",
    ]

    resources = [
      aws_cloudfront_distribution.this.arn
    ]
  }

  statement {
    sid = 2
    actions = [
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.this.arn}/*"
    ]
  }

  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]

    resources = [
      aws_s3_bucket.this.arn
    ]
  }
}

resource "aws_iam_group" "deployment" {
  name = "cdn-deployment-public-storage-${random_id.prefix.hex}"
}

resource "aws_iam_group_policy_attachment" "deployment" {
  group      = aws_iam_group.deployment.name
  policy_arn = aws_iam_policy.deployment_policy.arn
}


resource "aws_s3_bucket" "this" {
  bucket = var.bucket
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = data.aws_iam_policy_document.bucket.json
}

data "aws_iam_policy_document" "bucket" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadOnly"
    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${var.bucket}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        aws_cloudfront_distribution.this.arn
      ]
    }
  }
}
