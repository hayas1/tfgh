locals {
  repositories = {
    tfgh = {
      description = "managed by terraform"
    }
  }
}

module "repositories" {
  source       = "./module/repository"
  repositories = local.repositories
}
