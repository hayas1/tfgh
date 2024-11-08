module "repositories" {
  source = "./module/repository"
  repositories = {
    tfgh = {
      pr_required_environments = ["plan"]
    }
  }
}
