# Terraform module of GitHub repository
In addition to the repository itself, this module manages rulesets, labels, and other things that tend to define the same thing in various repositories.

# Implementation
## `github_repository_label` vs `github_issue_labels`
- https://registry.terraform.io/providers/integrations/github/latest/docs/resources/issue_label
- https://registry.terraform.io/providers/integrations/github/latest/docs/resources/issue_labels

The free tier terraform cloud can only manage 500 resources.
- https://www.hashicorp.com/blog/terraform-cloud-updates-plans-with-an-enhanced-free-tier-and-more-flexibility

Therefore, it is easy to avoid this limit by using `github_repository_labels`. However, `github_repository_labels` also needs to manage the default `good-first-issue` label and the `no-changes` label created by tfcmt, and so on. This is a lot of work, so we will adopt `github_repository_label`, and consider removing old repositories from Terraform management when we hit the 500 resource limit.

## Struggle to manage both default branch ruleset and labeler workflows
Prerequisites:
- The workflows such as labeler is managed in many repositories, so they should be managed by Terraform in default branch.
- The rulesets that deny directly push to default branch is set in managed repositories, so they should be managed by Terraform.

Terraform's GitHub provider support [github_repository_file](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) resource, which can be used to create a file in a repository. However, push it to default branch directly will be denied by the rulesets.

### Basic approach
Basic approach is to create a file in managed branch and create a pull request. The drawback of this method is that the order of `github_repository_file` cannot be specified in `for_each`, and an error due to already exists occurs when the PR branch is created on the first terraform apply.
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
Next approach is to create a branch first and then create a pull request. The drawback of this method is that the branch will be deleted when the pull request is merged. When the branch is deleted, next terraform plan will try to create the branch.
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
The problem of basic approach is the order of `github_repository_file`. So, consider creating one file first and then the other.
But, there is another problem. When `README.md` exists then terraform apply will fail even if set `overwrite_on_create = false`.
```hcl
resource "github_repository_file" "readme" { // here is changed
  repository = github_repository.this.name
  branch     = local.managed_pr_branch
  file       = "README.md"
  content    = ""
  ...
  overwrite_on_create             = false // here is changed
  autocreate_branch               = true
  autocreate_branch_source_branch = github_branch_default.this.branch
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

Therefore, `README.md` of the default branch is prepared as a data source. So, `README.md` of the default branch is prepared as the data source, and the content of `README.md` of the pull request branch is its content. Now the problem remains that terraform plan/apply fails if there is no `README.md` already in the repository...
```hcl
data "github_repository_file" "default_readme" { // here is changed
  repository = github_repository.this.name
  branch     = github_branch_default.this.branch
  file       = "README.md"
}
resource "github_repository_file" "readme" {
  repository = github_repository.this.name
  branch     = local.managed_pr_branch
  file       = "README.md"
  content    = data.github_repository_file.default_readme.content // here is changed
  ...
  overwrite_on_create             = false
  autocreate_branch               = true
  autocreate_branch_source_branch = github_branch_default.this.branch
}
resource "github_repository_file" "this" {
  for_each = local.github_snippets
  repository = github_repository.this.name
  branch     = local.managed_pr_branch
  ...
  overwrite_on_create             = true
  autocreate_branch               = false
  depends_on = [github_branch.readme]
}
resource "github_repository_pull_request" "managed" {
  base_repository = github_repository.this.name
  base_ref        = github_branch_default.this.branch
  head_ref        = local.managed_pr_branch
  ...
}
```
