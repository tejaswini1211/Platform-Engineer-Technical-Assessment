variable "aws_access_key" {
  description = "AWS access key (demo only)"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key (demo only)"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}
