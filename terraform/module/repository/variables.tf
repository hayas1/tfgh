variable "repositories" {
  type = map(object({
    description             = optional(string)
    visibility              = optional(string)
    additional_file_content = optional(map(string))
  }))
  nullable = false
}
