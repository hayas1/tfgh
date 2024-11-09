
locals {
  managed_pr_branch                = "chore/managed-by-terraform"
  managed_pr_commit_message_prefix = "Managed by Terraform"
  managed_pr_title                 = "files managed by Terraform"
  managed_pr_body = join("\n", [
    for f in local.github_files : "- .${f}"
  ])

  github_files = fileset(path.module, "github/**")
}

resource "github_repository_file" "this" {
  for_each = local.github_files

  repository          = github_repository.this.name
  branch              = local.managed_pr_branch
  file                = ".${each.value}"
  content             = join("\n", [file("${path.module}/${each.value}"), try(var.repo.additional_file_content[each.value], "")])
  commit_message      = "${local.managed_pr_commit_message_prefix}: .${each.value}"
  overwrite_on_create = true

  autocreate_branch               = true
  autocreate_branch_source_branch = github_repository.this.default_branch
}

resource "github_repository_pull_request" "managed" {
  base_repository = github_repository.this.name
  base_ref        = github_repository.this.default_branch
  head_ref        = local.managed_pr_branch
  title           = local.managed_pr_title
  body            = local.managed_pr_body

  depends_on = [github_repository_file.this]
}
