# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
resource "aws_s3_object" "assets" {
  # see https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  for_each = local.eligible_files.assets

  bucket       = local.s3_bucket
  content_type = lookup(local.mime_types, regex(var.file_extension_regex, each.value), null)
  key          = each.value
  source       = "${var.asset_paths.assets.local_path}${each.value}"

  # see https://developer.hashicorp.com/terraform/language/functions/filemd5
  source_hash   = filemd5("${var.asset_paths.assets.local_path}${each.value}")
  storage_class = var.s3_storage_class
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
resource "aws_s3_object" "minecraft_mods" {
  # see https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  for_each = local.eligible_files.minecraft_mods

  bucket       = local.s3_bucket
  content_type = lookup(local.mime_types, regex(var.file_extension_regex, each.value), null)
  key          = "${var.asset_paths.minecraft_mods.remote_path}/${each.value}"
  source       = "${var.asset_paths.minecraft_mods.local_path}${each.value}"

  # see https://developer.hashicorp.com/terraform/language/functions/filemd5
  source_hash   = filemd5("${var.asset_paths.minecraft_mods.local_path}${each.value}")
  storage_class = var.s3_storage_class
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
resource "aws_s3_object" "minecraft_modstxt" {
  bucket        = local.s3_bucket
  content_type  = local.mime_types.txt
  key           = "${var.asset_paths.minecraft_mods.remote_path}/mods.txt"
  content       = join("\n", local.minecraft_mod_urls)
  storage_class = var.s3_storage_class
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
resource "aws_s3_object" "minecraft_worlds" {
  # see https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  for_each = local.eligible_files.minecraft_worlds

  bucket       = local.s3_bucket
  content_type = lookup(local.mime_types, regex(var.file_extension_regex, each.value), null)
  key          = "${var.asset_paths.minecraft_worlds.remote_path}/${each.value}"
  source       = "${var.asset_paths.minecraft_worlds.local_path}${each.value}"

  # see https://developer.hashicorp.com/terraform/language/functions/filemd5
  source_hash   = filemd5("${var.asset_paths.minecraft_worlds.local_path}${each.value}")
  storage_class = var.s3_storage_class
}

locals {
  minecraft_modstxt_url = "${local.base_url}/${aws_s3_object.minecraft_modstxt.id}"

  minecraft_mod_urls = [
    for key, value in aws_s3_object.minecraft_mods : "${local.base_url}/${value.id}"
  ]

  minecraft_world_urls = [
    for key, value in aws_s3_object.minecraft_worlds : "${local.base_url}/${value.id}"
  ]
}
