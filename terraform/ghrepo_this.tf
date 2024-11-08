module "repositories" {
  source = "./module/repository"
  repositories = {
    tfgh = {}
  }
}

# data "github_repository" "tfgh" {
#   full_name = "hayas1/tfgh"
# }

# resource "github_repository_ruleset" "tfgh" {
#   name        = "default"
#   repository  = data.github_repository.tfgh.name
#   target      = "branch"
#   enforcement = "active"

#   conditions {
#     ref_name {
#       include = ["~DEFAULT_BRANCH"]
#       exclude = []
#     }
#   }

#   bypass_actors {
#     # https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_ruleset#bypass_actors
#     actor_id    = 5 # Admin
#     actor_type  = "RepositoryRole"
#     bypass_mode = "pull_request"
#   }

#   rules {
#     creation = true
#     deletion = true

#     non_fast_forward = true

#     required_deployments {
#       required_deployment_environments = [github_repository_environment.plan.environment]
#     }
#     # TODO required_check is required, but GUI can set it empty
#     # required_status_checks {
#     #   strict_required_status_checks_policy = true
#     # }

#     pull_request {}
#   }
# }

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
