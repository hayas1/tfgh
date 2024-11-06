terraform {
  cloud {
    organization = "h4ystack"
    hostname     = "app.terraform.io"

    workspaces {
      name = "tfgh"
    }
  }

  required_version = "~> 1.9"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  owner = "hayas1"
}
