# Terraform Cloud Workspace `web-assets-sync`

> This directory manages uploads of Web-accessible Assets for [@workloads](https://github.com/workloads).

## Table of Contents

<!-- TOC -->
* [Terraform Cloud Workspace `web-assets-sync`](#terraform-cloud-workspace-web-assets-sync)
  * [Table of Contents](#table-of-contents)
  * [Requirements](#requirements)
  * [Usage](#usage)
    * [Inputs](#inputs)
    * [Outputs](#outputs)
  * [Author Information](#author-information)
  * [License](#license)
<!-- TOC -->

## Requirements

- HashiCorp Terraform `1.6.x` or [newer](https://developer.hashicorp.com/packer/downloads)
- file-system acccess to public asset exports in `../assets/export`
- file-system acccess to public Minecraft mods `../minecraft-mods`
- file-system acccess to public Minecraft Worlds `../minecraft-worlds`

Optional, and only needed for documentation generation:

- `terraform-docs` `0.16.0` or [newer](https://terraform-docs.io/user-guide/installation/)

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

## Author Information

This repository is maintained by the contributors listed on [GitHub](https://github.com/workloads/web-assets-sync/graphs/contributors).

## License

Licensed under the Apache License, Version 2.0 (the "License").

You may obtain a copy of the License at [apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an _"AS IS"_ basis, without WARRANTIES or conditions of any kind, either express or implied.

See the License for the specific language governing permissions and limitations under the License.
