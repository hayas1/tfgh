resource "github_repository" "this" {
  name = var.name

  visibility             = var.repo.visibility
  delete_branch_on_merge = true
  auto_init              = true

  has_downloads = var.repo.has_downloads
  has_issues    = var.repo.has_issues
  has_projects  = var.repo.has_projects
  has_wiki      = var.repo.has_wiki

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [description, pages]
  }
}

resource "github_branch_default" "this" {
  repository = github_repository.this.name
  branch     = var.repo.default_branch

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
