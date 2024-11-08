locals {
  repositories = {
    tfgh = {
      pr_required_environments = ["plan"]
    }
  }
}

module "repositories" {
  source       = "./module/repository"
  repositories = local.repositories
}
