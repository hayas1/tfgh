resource "github_repository_environment" "plan" {
  environment = "plan"
  repository  = module.repositories.tfgh.managed.name

  lifecycle {
    prevent_destroy = true
  }
}
resource "github_repository_environment" "apply" {
  environment = "apply"
  repository  = module.repositories.tfgh.managed.name

  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = false
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_issue_label" "manual" {
  repository  = module.repositories.tfgh.managed.name
  name        = "manual"
  color       = regex("#([0-9A-Fa-f]{0,6})", "#5319E7")[0]
  description = "Do not terraform apply on merge, manual operation required"
}
