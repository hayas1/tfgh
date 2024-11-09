variable "name" {
  type     = string
  nullable = false
}

variable "repo" {
  type = object({
    default_branch          = optional(string, "master")
    description             = optional(string)
    visibility              = optional(string)
    additional_file_content = optional(map(string))
  })
  nullable = false
}
