locals {
  repositories = {
    tfgh = {
      description = "managed by terraform"
      additional_file_content = {
        "github/labeler.yml" = file("${path.module}/tfgh/github/labeler.yml")
      }
    }
  }
}

module "repositories" {
  source       = "./module/repository"
  repositories = local.repositories
}
