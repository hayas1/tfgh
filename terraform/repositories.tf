locals {
  repositories = {
    tfgh = {
      default_branch = "main"
    }
    devcontainer-features = {
      default_branch = "main"
      has_wiki       = true
    }
    dyson-rs = {
      default_branch = "master"
    }
    json-with-comments = {
      default_branch = "master"
    }
    tokei-toukei = {
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
