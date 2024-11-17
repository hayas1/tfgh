locals {
  labels = {
    "feature" : {
      color       = "#008B75"
      description = "New feature"
    },
    "breaking" : {
      color       = "#F84AD4"
      description = "Containing breaking changes"
    },
    "bugfix" : {
      color       = "#DE3659"
      description = "Fix some bugs"
    },
    "refactor" : {
      color       = "#BA5798"
      description = "Refactoring"
    },
    "documentation" : {
      color       = "#0075CA"
      description = "Documentation"
    },
    "deps" : {
      color       = "#36BF46"
      description = "Dependency updates"
    },
    "maintenance" : {
      color       = "#7F6054"
      description = "No effect on codebase"
    },
  }
}

resource "github_issue_label" "this" {
  for_each = local.labels

  repository  = github_repository.this.name
  name        = each.key
  color       = regex("#([0-9A-Fa-f]{0,6})", each.value.color)[0]
  description = each.value.description
}


