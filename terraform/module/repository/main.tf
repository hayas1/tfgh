resource "github_repository" "this" {
  for_each = var.repositories
  name     = each.key

  visibility             = each.value.visibility
  delete_branch_on_merge = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_repository_ruleset" "this" {
  for_each    = github_repository.this
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

    # TODO required_check is required, but GUI can set it empty
    # required_status_checks {
    #   strict_required_status_checks_policy = true
    # }

    pull_request {}
  }
}

locals {
  managed_pr_branch                = "chore/managed-by-terraform"
  managed_pr_commit_message_prefix = "Managed by Terraform"
  managed_pr_title                 = "files managed by Terraform"

  managed_pr_body = <<EOT
  - pull request template
  EOT
}

resource "github_repository_file" "pull_request_template" {
  for_each            = data.github_repository.this
  repository          = each.value.name
  branch              = local.managed_pr_branch
  file                = ".github/pull_request_template.md"
  content             = file("${path.module}/pull_request_template.md")
  commit_message      = "${local.managed_pr_commit_message_prefix}: pull request template"
  overwrite_on_create = true

  autocreate_branch               = true
  autocreate_branch_source_branch = each.value.default_branch
}

resource "github_repository_pull_request" "managed" {
  for_each        = data.github_repository.this
  base_repository = each.value.name
  base_ref        = each.value.default_branch
  head_ref        = local.managed_pr_branch
  title           = local.managed_pr_title
  body            = local.managed_pr_body
}
