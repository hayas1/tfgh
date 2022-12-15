provider "github" {
  token = var.GITHUB_TOKEN
}

variable "GITHUB_TOKEN" {
  type = string
}
