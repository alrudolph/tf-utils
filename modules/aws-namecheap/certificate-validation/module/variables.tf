variable "domain_name" {
  description = "The domain name to validate the certificate for"
  type        = string
}

variable "alternative_names" {
  description = "A list of subject alternative names for the certificate"
  type        = list(string)
  default     = []
}
