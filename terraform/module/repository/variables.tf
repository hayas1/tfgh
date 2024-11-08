variable "repositories" {
  type = map(object({
    description = optional(string)
    visibility  = optional(string)
  }))
  nullable = false
}
