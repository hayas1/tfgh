resource "github_repository" "tfgh" {
  name        = "tfgh"
  description = "managed by terraform"
  visibility  = "public"

  security_and_analysis {
    advanced_security {
      status = "enabled"
    }
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
  }
}

resource "github_branch_protection" "tfgh" {
  repository_id = github_repository.tfgh.node_id
  pattern       = "main"
  required_pull_request_reviews {
    required_approving_review_count = 0
  }
  required_status_checks {
    contexts = ["Terraform"]
  }
}
