data "github_repository" "this" {
  for_each  = var.repositories
  full_name = join("/", [each.value.owner, each.key])
}

resource "github_repository_ruleset" "this" {
  for_each    = data.github_repository.this
  name        = "default"
  repository  = each.value.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  bypass_actors {
    # https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_ruleset#bypass_actors
    actor_id    = 5 # Admin
    actor_type  = "RepositoryRole"
    bypass_mode = "pull_request"
  }

  rules {
    creation = true
    deletion = true

    non_fast_forward = true

    dynamic "required_deployments" {
      for_each = length(var.repositories[each.key].pr_required_environments) == 0 ? [] : [var.repositories[each.key].pr_required_environments]
      content {
        required_deployment_environments = required_deployments.value
      }
    }

    # TODO required_check is required, but GUI can set it empty
    # required_status_checks {
    #   strict_required_status_checks_policy = true
    # }

    pull_request {}
  }
}


resource "github_repository_file" "pull_request_template" {
  for_each            = data.github_repository.this
  repository          = each.key
  branch              = each.value.default_branch
  file                = ".github/pull_request_template.md"
  content             = file("${path.module}/pull_request_template.md")
  commit_message      = "pull_request_template managed by Terraform"
  overwrite_on_create = true
}
