resource "github_repository" "this" {
  name = var.name

  visibility             = var.repo.visibility
  description            = var.repo.description
  delete_branch_on_merge = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_branch" "default" {
  repository = github_repository.this.name
  branch     = var.repo.default_branch

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_branch_default" "this" {
  repository = github_repository.this.name
  branch     = github_branch.default.branch

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_repository_ruleset" "this" {
  name        = "default"
  repository  = github_repository.this.name
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

    # TODO required_check is required, but GUI can set it empty
    # required_status_checks {
    #   strict_required_status_checks_policy = true
    # }

    pull_request {}
  }
}
