# Terraform module of GitHub repository
In addition to the repository itself, this module manages rulesets, labels, and other things that tend to define the same thing in various repositories.

# Implementation
## `github_repository_label` vs `github_issue_labels`
- https://registry.terraform.io/providers/integrations/github/latest/docs/resources/issue_label
- https://registry.terraform.io/providers/integrations/github/latest/docs/resources/issue_labels

The free tier terraform cloud can only manage 500 resources.
- https://www.hashicorp.com/blog/terraform-cloud-updates-plans-with-an-enhanced-free-tier-and-more-flexibility

Therefore, it is easy to avoid this limit by using `github_repository_labels`. However, `github_repository_labels` also needs to manage the default `good-first-issue` label and the `no-changes` label created by tfcmt, and so on. This is a lot of work, so we will adopt `github_repository_label`, and consider removing old repositories from Terraform management when we hit the 500 resource limit.
