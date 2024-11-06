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
resource "github_repository_environment" "apply" {
  environment = "apply"
  repository  = github_repository.tfgh.name
}
