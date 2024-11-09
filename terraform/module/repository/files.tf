
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
  for_each = {
    for p in setproduct(
      [for k, v in github_repository.this : { key = k, value = v }],
      local.github_files
    )
    : "${p[0].key}.${p[1]}" => {
      repository = p[0].value
      local_path = p[1]
    }
  }

  repository          = each.value.repository.name
  branch              = local.managed_pr_branch
  file                = ".${each.value.local_path}"
  content             = file("${path.module}/${each.value.local_path}")
  commit_message      = "${local.managed_pr_commit_message_prefix}: .${each.value.local_path}"
  overwrite_on_create = true

  autocreate_branch               = true
  autocreate_branch_source_branch = each.value.repository.default_branch
}

resource "github_repository_pull_request" "managed" {
  for_each        = github_repository.this
  base_repository = each.value.name
  base_ref        = each.value.default_branch
  head_ref        = local.managed_pr_branch
  title           = local.managed_pr_title
  body            = local.managed_pr_body

  depends_on = [github_repository_file.this]
}
