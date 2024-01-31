terraform {
  required_version = ">= 1.7.1, < 1.8.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.69.1"
    }
  }
}
