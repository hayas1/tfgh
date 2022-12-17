# resource "github_repository" "dyson" {
#   name        = "dyson"
#   description = "dynamic json parser implemented by rust"
#   visibility  = "public"

#   has_downloads = true
#   has_issues    = true
#   has_projects  = true
#   has_wiki      = true
#   pages {
#     source {
#       branch = "GitHub Actions"
#     }
#   }

#   security_and_analysis {
#     advanced_security {
#       status = "enabled"
#     }
#     secret_scanning {
#       status = "enabled"
#     }
#     secret_scanning_push_protection {
#       status = "enabled"
#     }
#   }
# }

