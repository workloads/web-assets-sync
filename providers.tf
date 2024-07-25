# The AWS Provider is set to retrieve configuration from the executing environment
# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs#schema
provider "aws" {
  region = local.region

  # see https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags
  default_tags {
    tags = {
      "github:url" = "https://github.com/workloads/web-assets-sync"
    }
  }
}

# The HCP Terraform Provider is set to retrieve configuration from the executing environment
# see https://registry.terraform.io/providers/hashicorp/tfe/latest/docs#authentication
provider "tfe" {
  hostname        = "app.terraform.io"
  ssl_skip_verify = false
}
