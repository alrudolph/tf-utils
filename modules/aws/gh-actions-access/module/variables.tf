variable "github_repo" {
  description = "The GitHub repository to grant access to in the format: owner/repo-name"
  type        = string
  default     = null
}

variable "github_repos" {
  description = "The GitHub repositories to grant access to in the format: owner/repo-name"
  type        = list(string)
  default     = null
}

variable "role_name" {
  description = "The name of the IAM role to create for GitHub Actions"
  type        = string
}

variable "role_policy" {
  description = "The policy to attach to the IAM role to be able to apply Terraform changes"
  type        = string
}
