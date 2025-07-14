# Defines what variables your Terraform project expects.
# Sets types, descriptions, and optional default values.

# Example:

variable "admin_username" {
  type        = string
  description = "Admin username for the virtual machine"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for VM login"
}

