# required

variable "app_id" {
  type        = string
  description = "Application ID and S3 folder"
}

variable "context" {
  description = "Project context."

  type = object({
    namespace = string
    stage     = string
    name      = string
  })
}

variable "aliases" {
  type        = list(string)
  description = "List of CNAMEs"
}

variable "certificate_arn" {
  type        = string
  description = "AWS ACM certificate ARN."
}

variable "s3_bucket" {
  type        = string
  description = "S3 bucket for Cloudfront origin."
}

# optional

variable "apps_folder" {
  type        = string
  description = "Folder where apps are stored, must end with /."
  default     = "apps/"
}

variable "tags" {
  type        = map(string)
  description = "Tags attached to Cloudfront distribution."
  default     = {}
}

variable "custom_error_responses" {
  type = list(object({
    error_code            = number
    error_caching_min_ttl = number
    response_code         = number
    response_page_path    = string
  }))

  default = []

  description = "List of custom error responses for distribution."
}

variable "certificate_minimum_protocol_version" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#minimum_protocol_version
  type        = string
  default     = "TLSv1.2_2019"
  description = "The minimum version of the SSL protocol that you want to use for HTTPS."
}

variable "default_root_object" {
  type        = string
  description = "The object that you want CDN to return when an user requests the root URL."
  default     = "index.html"
}

variable "default_cache_behavior" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#default-cache-behavior-arguments
  type = object({
    allowed_methods = list(string),
    cached_methods  = list(string),
    min_ttl         = number
    max_ttl         = number
    default_ttl     = number
    compress        = bool
  })

  default = {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]
    min_ttl         = 0
    default_ttl     = 3600  # 1 hour
    max_ttl         = 86400 # 1 day
    compress        = true
  }

  description = "Default cache behavior for this distribution"
}

variable "response_headers_policy_id" {
  type        = string
  description = "The identifier for a response headers policy."
  default     = null
}

variable "price_class" {
  type        = string
  description = "Cloudfront distribution's price class."
  default     = "PriceClass_100"
}

variable "viewer_request_lambda_arn" {
  type        = string
  description = "ARN of the Lambda function to associate with the distribution on the ViewerRequest event."
  default     = null
}
