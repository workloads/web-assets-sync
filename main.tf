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

locals {
  # iterate over the list of files in the Minecraft Mods directory,
  # and return a list of subdirectories using `dirname`,
  # then remove duplicates items using `distinct`
  # see https://developer.hashicorp.com/terraform/language/functions/distinct
  minecraft_modset_paths = distinct([
    # see https://developer.hashicorp.com/terraform/language/functions/dirname
    for file in aws_s3_object.minecraft_mods : dirname(file.id)
  ])

  minecraft_mod_urls = {
    # iterate over the list of all mod URLs that are available on the remote (S3 Bucket)
    # reformat the `local` value as an object, with keys set as the `basename` of each mod set
    # and values set as a list of URLs for each file matching the name of the mod set. Im sorry.
    # see https://developer.hashicorp.com/terraform/language/functions/basename
    for setIndex, setValue in local.minecraft_modset_paths : basename(local.minecraft_modset_paths[setIndex]) => [
      # see https://developer.hashicorp.com/terraform/language/functions/startswith
      for fileIndex, fileValue in aws_s3_object.minecraft_mods : "${local.base_url}/${replace(fileValue.id, "+", "%2B")}" if startswith(fileValue.id, local.minecraft_modset_paths[setIndex])
    ]
  }
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
resource "aws_s3_object" "minecraft_modstxt_files" {
  # see https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  for_each = local.minecraft_mod_urls

  bucket        = local.s3_bucket
  content_type  = local.mime_types.txt
  key           = "${var.asset_paths.minecraft_mods.remote_path}/${each.key}/${var.modstxt_file_name}"
  content       = join("\n", each.value)
  storage_class = var.s3_storage_class
}

locals {
  minecraft_modstxt_urls = {
    for key, value in aws_s3_object.minecraft_modstxt_files : key => "${local.base_url}/${value.key}"
  }

  minecraft_world_urls = [
    for key, value in aws_s3_object.minecraft_worlds : "${local.base_url}/${value.id}"
  ]
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
