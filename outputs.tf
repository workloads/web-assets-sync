output "aws_cli_commands" {
  description = "AWS CLI Command for CloudFront operations."

  value = {
    create_invalidation = "aws cloudfront create-invalidation --distribution-id '${local.cloudfront_distribution_id}' --paths '/*'"
  }
}

output "aws_console_url" {
  description = "AWS Console URL."
  value       = "https://us-east-1.console.aws.amazon.com/cloudfront/v3/home?region=${local.region}#/distributions/${local.cloudfront_distribution_id}"
}

output "eligible_files" {
  description = "List of Sync-Eligible Assets."
  value       = local.eligible_files
}

output "minecraft_modstxt_url" {
  description = "URL of Minecraft `mods.txt` File."
  value       = local.minecraft_modstxt_url
}

output "minecraft_mod_urls" {
  description = "URLs of Minecraft Mods."
  value       = local.minecraft_mod_urls
}

output "minecraft_world_urls" {
  description = "URLs of Minecraft Worlds."

  value = local.minecraft_world_urls
}
