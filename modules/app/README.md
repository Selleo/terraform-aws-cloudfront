## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |
| [aws_iam_policy.deployment_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_s3_bucket.apps](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aliases"></a> [aliases](#input\_aliases) | List of CNAMEs | `list(string)` | n/a | yes |
| <a name="input_app_id"></a> [app\_id](#input\_app\_id) | Application ID and S3 folder | `string` | n/a | yes |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | AWS ACM certificate ARN. | `string` | n/a | yes |
| <a name="input_certificate_minimum_protocol_version"></a> [certificate\_minimum\_protocol\_version](#input\_certificate\_minimum\_protocol\_version) | The minimum version of the SSL protocol that you want to use for HTTPS. | `string` | `"TLSv1.2_2019"` | no |
| <a name="input_custom_error_responses"></a> [custom\_error\_responses](#input\_custom\_error\_responses) | List of custom error responses for distribution. | <pre>list(object({<br>    error_code            = number<br>    error_caching_min_ttl = number<br>    response_code         = number<br>    response_page_path    = string<br>  }))</pre> | `[]` | no |
| <a name="input_default_cache_behavior"></a> [default\_cache\_behavior](#input\_default\_cache\_behavior) | Default cache behavior for this distribution | <pre>object({<br>    allowed_methods = list(string),<br>    cached_methods  = list(string),<br>    min_ttl         = number<br>    max_ttl         = number<br>    default_ttl     = number<br>    compress        = bool<br>  })</pre> | <pre>{<br>  "allowed_methods": [<br>    "DELETE",<br>    "GET",<br>    "HEAD",<br>    "OPTIONS",<br>    "PATCH",<br>    "POST",<br>    "PUT"<br>  ],<br>  "cached_methods": [<br>    "GET",<br>    "HEAD"<br>  ],<br>  "compress": true,<br>  "default_ttl": 3600,<br>  "max_ttl": 86400,<br>  "min_ttl": 0<br>}</pre> | no |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | The object that you want CDN to return when an user requests the root URL. | `string` | `"index.html"` | no |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | Cloudfront distribution's price class. | `string` | `"PriceClass_100"` | no |
| <a name="input_response_headers_policy_id"></a> [response\_headers\_policy\_id](#input\_response\_headers\_policy\_id) | The identifier for a response headers policy. | `string` | `null` | no |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | S3 bucket for Cloudfront origin. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags attached to Cloudfront distribution. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | CDN distribution ARN. |
| <a name="output_deployment_policy_id"></a> [deployment\_policy\_id](#output\_deployment\_policy\_id) | IAM policy for deploying CloudFront distribution. |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | CDN distribution's domain name. |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | CDN Route 53 zone ID. |
| <a name="output_id"></a> [id](#output\_id) | CDN distribution ID. |
| <a name="output_oai_iam_arn"></a> [oai\_iam\_arn](#output\_oai\_iam\_arn) | Origin Access Identity pre-generated ARN that can be used in S3 bucket policies. |
