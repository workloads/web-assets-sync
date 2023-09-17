variable "asset_paths" {
  type = object({
    assets = object({
      extensions  = string
      local_path  = string
      remote_path = optional(string)
    }),

    minecraft_mods = object({
      extensions  = string
      local_path  = string
      remote_path = optional(string)
    })

    minecraft_worlds = object({
      extensions  = string
      local_path  = string
      remote_path = optional(string)
    })
  })

  description = "Sync-eligible Path Objects."

  default = {
    assets = {
      extensions = "**/*.{gif,jpg,jpeg,png,svg}"
      local_path = "../assets/exported/"
    }

    # Terraform will consider subdirectories in this path as separate sets of mods
    # and will lifecycle manage a per-set `mods.txt` file accordingly
    minecraft_mods = {
      extensions  = "**/*.{jar,zip}"
      local_path  = "../minecraft-mods/"
      remote_path = "minecraft/mods"
    }

    minecraft_worlds = {
      extensions  = "**/*.{zip}"
      local_path  = "../minecraft-worlds/"
      remote_path = "minecraft/worlds"
    }
  }
}

variable "file_extension_regex" {
  type        = string
  description = "Regular Expression to match File Extensions."
  default     = "[^.]+$"
}

variable "modstxt_file_name" {
  type        = string
  description = "Name of the per-modset `mods.txt` file."
  default     = "mods.txt"
}

variable "s3_storage_class" {
  type        = string
  description = "Storage Class of S3 Object."
  default     = "STANDARD"
}

variable "tfe_organization" {
  type        = string
  description = "Terraform Cloud Organization."
  default     = "workloads"
}

variable "tfe_workspace_assets" {
  type        = string
  description = "Terraform Cloud Workspace for `web-assets`."
  default     = "web-assets"
}

locals {
  # list of eligible files, based on path and file extension(s)
  eligible_files = {
    # get keys of eligible files, and map them to their respective filesets
    # see https://developer.hashicorp.com/terraform/language/functions/keys
    for group in keys(var.asset_paths) : group => fileset(var.asset_paths[group].local_path, var.asset_paths[group].extensions)
  }

  # curated set of MIME types, relevant for the files we're syncing
  # see https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
  # and https://www.iana.org/assignments/media-types/media-types.xhtml
  mime_types = {
    gif  = "image/gif"
    htm  = "text/html"
    html = "text/html"
    jar  = "application/java-archive"
    jpg  = "image/jpeg"
    jpeg = "image/jpeg"
    png  = "image/png"
    svg  = "image/svg+xml"
    txt  = "text/plain"
    zip  = "application/zip"
  }
}
