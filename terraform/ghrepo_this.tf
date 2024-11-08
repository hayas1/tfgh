module "repositories" {
  source = "./module/repository"
  repositories = {
    tfgh = {
      pr_required_environments = ["plan"]
    }
  }
}

resource "github_repository_environment" "plan" {
  environment = "plan"
  repository  = module.repositories.imported.tfgh.name
}
resource "github_repository_environment" "apply" {
  environment = "apply"
  repository  = module.repositories.imported.tfgh.name

  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = false
  }
}
