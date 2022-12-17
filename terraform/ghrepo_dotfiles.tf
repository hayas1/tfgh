resource "github_repository" "dotfiles" {
  name        = "dotfiles"
  description = "dotfiles for devcontainer"
  visibility  = "public"

  has_downloads = true
  has_issues    = true
  has_projects  = true
  has_wiki      = true

  lifecycle {
    prevent_destroy = true
  }

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

