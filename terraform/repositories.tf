locals {
  repositories = {
    tfgh = {
      default_branch = "main"
      additional_file_content = {
        "github/labeler.yml" = file("${path.module}/additional/tfgh/github/labeler.yml")
      }
    }
    devcontainer-features = {
      default_branch = "main"
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
