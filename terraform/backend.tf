terraform {
  cloud {
    organization = "h4ystack"
    hostname     = "app.terraform.io"

    workspaces {
      name = "tfgh"
    }
  }

  required_version = "~> 1.9"
}

provider "github" {
  token = var.GITHUB_TOKEN
}

variable "GITHUB_TOKEN" {
  type = string
}
