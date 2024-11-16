# Terraform module of GitHub repository
In addition to the repository itself, this module manages rulesets, labels, and other things that tend to define the same thing in various repositories.

# Implementation
## `github_issue_label` vs `github_issue_labels`
The document of `github_issue_label` and `github_issue_labels` are as follows.
- https://registry.terraform.io/providers/integrations/github/latest/docs/resources/issue_label
- https://registry.terraform.io/providers/integrations/github/latest/docs/resources/issue_labels

The free tier terraform cloud can only manage 500 resources.
- https://www.hashicorp.com/blog/terraform-cloud-updates-plans-with-an-enhanced-free-tier-and-more-flexibility

Therefore, it is easy to avoid this limit by using `github_issue_labels`. However, `github_issue_labels` also needs to manage the default `good-first-issue` label and the `no-changes` label created by tfcmt, and so on. This is a lot of work, so we will adopt `github_issue_label`, and consider removing old repositories from Terraform management when we hit the 500 resource limit.

## Struggle to manage both default branch ruleset and labeler workflows
Prerequisites:
- The workflows such as labeler is managed in many repositories, so they should be managed by Terraform in default branch.
- The rulesets that deny directly push to default branch is set in many repositories, so they should be managed by Terraform.

Terraform's GitHub provider support [github_repository_file](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) resource, which can be used to create a file in a repository. However, push it to default branch directly will be denied by the rulesets.

### Basic approach
Basic approach is to create a file in managed branch and create a pull request. The drawback of this method is that the order of `github_repository_file` cannot be specified in `for_each`, so an error due to the branch already exists occurs when the second or after file is created on the first terraform apply.
```hcl
resource "github_repository_file" "this" {
  for_each = local.github_snippets
  repository = github_repository.this.name
  branch     = local.managed_pr_branch
  ...
  overwrite_on_create             = true
  autocreate_branch               = true
  autocreate_branch_source_branch = github_branch_default.this.branch
}
resource "github_repository_pull_request" "managed" {
  base_repository = github_repository.this.name
  base_ref        = github_branch_default.this.branch
  head_ref        = local.managed_pr_branch
  ...
}
```

### Create pull request branch in advance
Next approach is to create a branch first and then create a pull request. The drawback of this method is that after the pull request is merged and the branch is deleted, the next terraform plan will try to create the branch.
```hcl
resource "github_branch" "managed" { // here is changed
  repository = github_repository.this.name
  branch     = local.managed_pr_branch
}
resource "github_repository_file" "this" {
  for_each = local.github_snippets
  repository = github_repository.this.name
  branch     = local.managed_pr_branch
  ...
  overwrite_on_create             = true
  autocreate_branch               = false // here is changed
  depends_on = [github_branch.managed] // here is changed
}
resource "github_repository_pull_request" "managed" {
  base_repository = github_repository.this.name
  base_ref        = github_branch_default.this.branch
  head_ref        = local.managed_pr_branch
  ...
}
```

### One file and branch for pull request
The problem of basic approach is the order of `github_repository_file`. So, consider creating one file first and then the others.
But, there is another problem. When `README.md` exists then terraform apply will fail even if set `overwrite_on_create = false`. So set `ignore_changes = [content]` for `README.md`.
```hcl
resource "github_repository_file" "readme" { // here is changed
  repository = github_repository.this.name
  branch     = local.managed_pr_branch
  file       = "README.md"
  content    = ""
  ...
  overwrite_on_create             = true
  autocreate_branch               = true
  autocreate_branch_source_branch = github_branch_default.this.branch

  lifecycle {
    ignore_changes = [content] // here is changed
  }
}
resource "github_repository_file" "this" {
  for_each = local.github_snippets
  repository = github_repository.this.name
  branch     = local.managed_pr_branch
  ...
  overwrite_on_create             = true
  autocreate_branch               = false // here is changed
  depends_on = [github_branch.readme] // here is changed
}
resource "github_repository_pull_request" "managed" {
  base_repository = github_repository.this.name
  base_ref        = github_branch_default.this.branch
  head_ref        = local.managed_pr_branch
  ...
}
```
