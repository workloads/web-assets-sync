# see https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/outputs
data "tfe_outputs" "web_assets" {
  organization = var.tfe_organization
  workspace    = var.tfe_workspace_assets
}

locals {
  # simplify access to the outputs
  upstream_values = data.tfe_outputs.web_assets.nonsensitive_values

  # CloudFront-specific values
  base_url                   = "https://${one(local.upstream_values.aws_cloudfront_aliases)}"
  cloudfront_distribution_id = local.upstream_values.aws_cloudfront_distribution_id
  region                     = local.upstream_values.aws_region
  s3_bucket                  = local.upstream_values.aws_s3_bucket
}
