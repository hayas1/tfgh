resource "github_repository" "dotfiles" {
  name        = "dotfiles"
  description = "dotfiles for devcontainer"
  visibility  = "public"

  has_downloads = true
  has_issues    = true
  has_projects  = true
  has_wiki      = true

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

resource "github_branch_protection" "dotfiles" {
  repository_id = github_repository.dotfiles.node_id
  pattern       = "master"
  required_pull_request_reviews {
    required_approving_review_count = 0
  }
}
