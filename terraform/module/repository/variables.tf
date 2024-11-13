variable "name" {
  type     = string
  nullable = false
}

variable "repo" {
  type = object({
    default_branch = optional(string, "master")
    visibility     = optional(string)

    has_downloads = optional(bool)
    has_issues    = optional(bool, true)
    has_projects  = optional(bool)
    has_wiki      = optional(bool)

    additional_file_content = optional(map(string))
  })
  nullable = false
}
