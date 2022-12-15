terraform {
  cloud {
    organization = "h4ystack"
    hostname     = "app.terraform.io"

    workspaces {
      name = "tfgh"
    }
  }
}
