resource "github_repository" "dotfiles" {
  name        = "dotfiles"
  description = "dotfiles for devcontainer"
  visibility  = "public"

  has_downloads = true
  has_issues    = true
  has_projects  = true
  has_wiki      = true
}
