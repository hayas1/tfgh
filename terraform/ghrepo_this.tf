resource "github_repository" "tfgh" {
  name        = "tfgh"
  description = "managed by terraform"
  visibility  = "public"

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_repository_environment" "plan" {
  environment = "plan"
  repository  = github_repository.tfgh.name
}
# data "github_actions_environment_secrets" "plan" {
#   repository  = github_repository.tfgh.name
#   environment = github_repository_environment.plan.environment
# }
