resource "github_repository_environment" "plan" {
  environment = "plan"
  repository  = module.repositories.tfgh.managed.name
}
resource "github_repository_environment" "apply" {
  environment = "apply"
  repository  = module.repositories.tfgh.managed.name

  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = false
  }
}

resource "github_issue_label" "manual" {
  repository  = module.repositories.tfgh.managed.name
  name        = "manual"
  color       = "5319E7"
  description = "Do not terraform apply on merge, manual operation required"
}
