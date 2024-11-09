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

resource "github_issue_label" "this" {
  for_each = {
    for p in setproduct(
      [for k, v in github_repository.this : { key = k, value = v }],
      [for k, v in local.labels : { key = k, value = v }]
    )
    : "${p[0].key}.${p[1].key}" => {
      repository = p[0].value
      label_name = p[1].key
      label      = p[1].value
    }
  }
  repository  = each.value.repository.name
  name        = each.value.label_name
  color       = each.value.label.color
  description = each.value.label.description
}
