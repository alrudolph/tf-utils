variable "github_repo" {
  description = "The GitHub repository to grant access to in the format: owner/repo-name"
  type        = string
}

variable "role_name" {
  description = "The name of the IAM role to create for GitHub Actions"
  type        = string
}

variable "role_policy" {
  description = "The policy to attach to the IAM role to be able to apply Terraform changes"
  type        = string
}
