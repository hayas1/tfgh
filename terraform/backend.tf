terraform {
  cloud {
    organization = "h4ystack"
    hostname     = "app.terraform.io"

    workspaces {
      name = "tfgh"
    }
  }
}

provider "github" {
  token = var.GITHUB_TOKEN
}

variable "GITHUB_TOKEN" {
  type = string
}
