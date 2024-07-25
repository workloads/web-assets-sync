# Terraform Cloud Workspace `web-assets-sync`

> This repository manages uploads of web-accessible Assets for [@workloads](https://github.com/workloads).

## Table of Contents

<!-- TOC -->
* [Terraform Cloud Workspace `web-assets-sync`](#terraform-cloud-workspace-web-assets-sync)
  * [Table of Contents](#table-of-contents)
  * [Requirements](#requirements)
  * [Usage](#usage)
    * [Inputs](#inputs)
    * [Outputs](#outputs)
  * [Notes](#notes)
    * [Sensitive Data](#sensitive-data)
  * [Contributors](#contributors)
  * [License](#license)
<!-- TOC -->

## Requirements

- HashiCorp Terraform `1.9.x` or [newer](https://developer.hashicorp.com/terraform/downloads)
- file-system access to public asset exports in `../assets/export`
- file-system access to public Minecraft mods `../minecraft-mods`
- file-system access to public Minecraft Worlds `../minecraft-worlds`

Optional, and only needed for documentation generation:

- `terraform-docs` `0.18.0` or [newer](https://terraform-docs.io/user-guide/installation/)

## Usage

This repository uses a standard Terraform workflow (`init`, `plan`, `apply`).

For more information, including detailed usage guidelines, see the [Terraform documentation](https://developer.hashicorp.com/terraform/cli/commands).

<!-- BEGIN_TF_DOCS -->
### Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| asset_paths | Sync-eligible Path Objects. | <pre>object({<br>    assets = object({<br>      extensions  = string<br>      local_path  = string<br>      remote_path = optional(string)<br>    }),<br><br>    minecraft_mods = object({<br>      extensions  = string<br>      local_path  = string<br>      remote_path = optional(string)<br>    })<br><br>    minecraft_worlds = object({<br>      extensions  = string<br>      local_path  = string<br>      remote_path = optional(string)<br>    })<br>  })</pre> | no |
| file_extension_regex | Regular Expression to match File Extensions. | `string` | no |
| modstxt_file_name | Name of the per-modset `mods.txt` file. | `string` | no |
| s3_storage_class | Storage Class of S3 Object. | `string` | no |
| tfe_organization | Terraform Cloud Organization. | `string` | no |
| tfe_workspace_assets | Terraform Cloud Workspace for `web-assets`. | `string` | no |

### Outputs

| Name | Description |
|------|-------------|
| aws_cli_commands | AWS CLI Command for CloudFront operations. |
| aws_console_url | AWS Console URL. |
| eligible_files | List of Sync-Eligible Assets. |
| minecraft_mod_urls | URLs of Minecraft Mods. |
| minecraft_modstxt_urls | URL of Minecraft `mods.txt` Files. |
| minecraft_world_urls | URLs of Minecraft Worlds. |
<!-- END_TF_DOCS -->

## Notes

### Sensitive Data

Terraform state may contain [sensitive data](https://developer.hashicorp.com/terraform/language/state/sensitive-data). This workspace uses [Terraform Cloud](https://developer.hashicorp.com/terraform/cloud-docs) to safely store state, and encrypt the data at rest.

## Contributors

For a list of current (and past) contributors to this repository, see [GitHub](https://github.com/workloads/web-assets-sync/graphs/contributors).

## License

Licensed under the Apache License, Version 2.0 (the "License").

You may download a copy of the License at [apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).

See the License for the specific language governing permissions and limitations under the License.
