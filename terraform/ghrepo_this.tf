data "github_repository" "tfgh" {
  full_name = "hayas1/tfgh"
}

resource "github_repository_ruleset" "tfgh" {
  name        = "default"
  repository  = data.github_repository.tfgh.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    creation = true
    update   = true
    deletion = true

    pull_request {}
  }
}

resource "github_repository_environment" "plan" {
  environment = "plan"
  repository  = data.github_repository.tfgh.name
}
resource "github_repository_environment" "apply" {
  environment = "apply"
  repository  = data.github_repository.tfgh.name

  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = false
  }
}
