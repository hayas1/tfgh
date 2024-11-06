data "github_repository" "tfgh" {
  full_name = "hayas1/tfgh"
}

resource "github_repository_environment" "plan" {
  environment = "plan"
  repository  = data.github_repository.tfgh.name
}
resource "github_repository_environment" "apply" {
  environment = "apply"
  repository  = data.github_repository.tfgh.name
}
