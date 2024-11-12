locals {
  repositories = {
    tfgh = {
      default_branch = "main"
      description    = "managed by terraform"
      additional_file_content = {
        "github/labeler.yml" = file("${path.module}/tfgh/github/labeler.yml")
      }
    }
    dyson-rs = {
      default_branch = "master"
    }
  }
}

module "repositories" {
  for_each = local.repositories
  source   = "./module/repository"
  name     = each.key
  repo     = each.value
}
