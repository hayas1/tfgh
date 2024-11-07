# About
Repositories are managed by Terraform.

# Architecture
<!-- https://icones.js.org/collection/logos -->
```mermaid
architecture-beta
    %% group api(logos:github-icon)[GitHub]
    group api(internet)[GitHub]

    service this(server)[this] in api
    service repos(disk)[Repositories] in api

    %% this:B -- T:repos

    %% group backends(logos:terraform-icon)[Terraform Cloud]
    group backends(cloud)[Terraform Cloud]
    service backend(database)[tfstate] in backends

    this:R --> L:backend
    repos{group}:R <-- B:backend{group}
```

## Backend: Terraform Cloud
tfstate is managed in [Terraform Cloud](https://app.terraform.io/app).

Execution mode is set to [local](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/settings#execution-mode), so terraform plan/apply will be executed in local machine or GitHub Actions.

## GitHub App: Terraform Plan / Apply
For terraform plan/apply in GitHub Actions, GitHub App is configured.
- Terraform Plan: https://github.com/settings/apps/terraform-plan
- Terraform Apply: https://github.com/settings/apps/terraform-apply

> [!WARNING]
These GitHub Apps are not managed by terraform. Managing GitHub Apps itself is not supported in GitHub provider now. Data source is only available in v6.3.1.
https://registry.terraform.io/providers/integrations/github/latest/docs

