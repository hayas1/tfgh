# About
Repositories are managed by Terraform.

# Architecture
<!-- https://icones.js.org/collection/logos -->
```mermaid
architecture-beta
    %% group repositories(logos:github-icon)[GitHub]
    group repositories(internet)[GitHub]

    service this(server)[tfgh] in repositories
    service repos(disk)[Repositories] in repositories


    %% group backend(logos:terraform-icon)[Terraform Cloud]
    group backend(cloud)[Terraform Cloud]
    service tfstate(database)[tfstate] in backend

    junction gha

    this:R -- L:gha
    gha:R --> L:tfstate
    repos{group}:R <-- B:gha
```

## Backend: Terraform Cloud
tfstate is managed in [Terraform Cloud](https://app.terraform.io/app).

Execution mode is set to [local](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/settings#execution-mode), so terraform plan/apply will be executed in local machine or GitHub Actions.

## GitHub App: Terraform Plan / Apply
For terraform plan/apply in GitHub Actions, GitHub App is configured.
- Terraform Plan: https://github.com/settings/apps/terraform-plan
- Terraform Apply: https://github.com/settings/apps/terraform-apply

> [!WARNING]
> These GitHub Apps are **not** managed by terraform. Managing GitHub Apps itself is not supported in GitHub provider now. Data source is only available in v6.3.1.
> https://registry.terraform.io/providers/integrations/github/latest/docs

## GitHub Environments: Terraform Plan / Apply
For terraform plan/apply in GitHub Actions, GitHub Environment is configured.
- plan/apply: https://github.com/hayas1/tfgh/settings/environments

> [!NOTE]
> These GitHub Environments are managed by terraform.

These GitHub Environments host some secrets for terraform plan/apply in GitHub Actions.

| Secret          | How to obtain when expired                                                                                                                   |
| --------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| APP_ID          | GitHub Apps [plan](https://github.com/settings/apps/terraform-plan)/[apply](https://github.com/settings/apps/terraform-apply) settings page. |
| APP_PRIVATE_KEY | GitHub Apps settings page too. **Not Client secrets, just Private keys.**                                                                    |
| TF_API_TOKEN    | Terraform Cloud [user setting](https://app.terraform.io/app/settings/tokens) page. For both plan/apply.                                      |

> [!IMPORTANT]
> These secrets are **not** managed by terraform. Managing secrets in terraform is not recommended because they are stored in plain text in tfstate

# Operations
## Terraform Plan / Apply in local machine
```sh
cd terraform
terraform login
terraform init
terraform plan
terraform apply
```
`terraform login` require authorization token from Terraform Cloud.
