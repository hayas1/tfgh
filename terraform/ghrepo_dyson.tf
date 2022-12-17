resource "github_repository" "dyson" {
  name        = "dyson"
  description = "dynamic json parser implemented by rust"
  visibility  = "public"

  has_downloads = true
  has_issues    = true
  has_projects  = true
  has_wiki      = true
}

