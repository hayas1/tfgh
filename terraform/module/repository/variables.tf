variable "repositories" {
  type = map(object({
    owner = optional(string, "hayas1")
  }))
  nullable = false
}
