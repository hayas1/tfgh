variable "repositories" {
  type = map(object({
    owner                    = optional(string, "hayas1")
    pr_required_environments = optional(list(string), [])
  }))
  nullable = false
}
