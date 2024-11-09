
locals {
  managed_pr_branch                = "chore/managed-by-terraform"
  managed_pr_commit_message_prefix = "Managed by Terraform"
  managed_pr_title                 = "files managed by Terraform"

  managed_pr_body = <<EOT
  - pull request template
  EOT
}

resource "github_repository_file" "pull_request_template" {
  for_each            = github_repository.this
  repository          = each.value.name
  branch              = local.managed_pr_branch
  file                = ".github/pull_request_template.md"
  content             = file("${path.module}/github/pull_request_template.md")
  commit_message      = "${local.managed_pr_commit_message_prefix}: pull request template"
  overwrite_on_create = true

  autocreate_branch               = true
  autocreate_branch_source_branch = each.value.default_branch
}

resource "github_repository_pull_request" "managed" {
  for_each        = github_repository.this
  base_repository = each.value.name
  base_ref        = each.value.default_branch
  head_ref        = local.managed_pr_branch
  title           = local.managed_pr_title
  body            = local.managed_pr_body

  depends_on = [github_repository_file.pull_request_template]
}
