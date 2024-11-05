resource "github_repository" "tfgh" {
  name        = "tfgh"
  description = "managed by terraform"
  visibility  = "public"

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
