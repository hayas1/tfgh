# About
repositories managed by Terraform.

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
