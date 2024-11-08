resource "github_repository_environment" "plan" {
  environment = "plan"
  repository  = module.repositories.managed.tfgh.name
}
resource "github_repository_environment" "apply" {
  environment = "apply"
  repository  = module.repositories.managed.tfgh.name

  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = false
  }
}
