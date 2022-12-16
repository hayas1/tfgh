resource "github_repository" "tfgh" {
  name        = "tfgh"
  description = "managed by terraform"
  visibility  = "public"
}

resource "github_branch_protection" "tfgh" {
  repository_id = github_repository.tfgh.node_id
  pattern       = "main"
  required_pull_request_reviews {
    required_approving_review_count = 0
  }
  required_status_checks {
    strict   = true
    contexts = ["github/terraform"]
  }
}
