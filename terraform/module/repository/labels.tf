locals {
  labels = {
    "feature" : {
      color       = "008B75"
      description = "New feature"
    },
    "breaking" : {
      color       = "F84AD4"
      description = "Containing breaking changes"
    },
    "bugfix" : {
      color       = "DE3659"
      description = "Fix some bugs"
    },
    "refactor" : {
      color       = "BA5798"
      description = "Refactoring"
    },
    "documentation" : {
      color       = "0075CA"
      description = "Documentation"
    },
    "deps" : {
      color       = "36BF46"
      description = "Dependency updates"
    },
    "maintenance" : {
      color       = "7F6054"
      description = "No effect on codebase"
    },
  }

  release_label = {
    color       = "6B2AD2"
    description = "Release when merged"
  }
}

resource "github_issue_labels" "this" {

  repository = github_repository.this.name

  dynamic "label" {
    for_each = local.labels

    content {
      name        = label.key
      color       = label.value.color
      description = label.value.description
    }
  }

}
