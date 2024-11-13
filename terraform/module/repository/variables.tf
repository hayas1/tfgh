variable "name" {
  type     = string
  nullable = false
}

variable "repo" {
  type = object({
    default_branch          = optional(string, "master")
    visibility              = optional(string)
    additional_file_content = optional(map(string))
  })
  nullable = false
}
