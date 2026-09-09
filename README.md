# Databricks sql warehouse Terraform module

One SQL warehouse.

Creates one SQL warehouse and, when `permissions` is not empty, one `databricks_permissions` block on it. The module turns the `tags` map into `tags { custom_tags { ... } }` blocks.

## Resources

- `databricks_sql_endpoint.this`
- `databricks_permissions.this[0]` (count = 1 only when `permissions` is not empty)

The resource addresses above are part of the DataTF import contract. Do not rename them.

## Usage

```hcl
module "warehouse" {
  source  = "536tech/sql-warehouse/databricks"
  version = "1.0.0"

  name                      = "Analytics WH"
  cluster_size              = "Small"
  min_num_clusters          = 1
  max_num_clusters          = 3
  auto_stop_mins            = 20
  warehouse_type            = "PRO"
  enable_photon             = true
  enable_serverless_compute = true

  tags = {
    team = "analytics"
  }

  permissions = [{
    permission_level = "CAN_USE"
    group_name       = "analysts"
  }]
}
```

## Compatibility

Configure the Databricks provider in the calling root with a workspace endpoint.
This resource module is also used by the
[workspace pattern module](https://registry.terraform.io/modules/536tech/workspace/databricks/latest).
Each repository has its own releases. Consumers select an exact tested module version.

The resource addresses match the original workspace submodule in version 0.1.1.
To migrate a direct submodule call, change its source and version. Keep the module block name.
Run `terraform init` and require a plan with no resource changes.
DataTF exports continue to use the workspace pattern module and its existing import addresses.

## Development

Use Terraform 1.7 or later for the mock tests. The module supports Terraform 1.5 or later.

```sh
prek install
terraform init -backend=false -lockfile=readonly
terraform validate
terraform test
tflint --recursive
prek run --all-files
```

CI tests the committed provider version and the minimum supported provider, 1.128.0.
The workspace pattern module checks the complete DataTF contract and its integration behavior.

## License

[Apache-2.0](LICENSE).

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- terraform (>= 1.5.0)

- databricks (>= 1.128.0, < 2.0.0)

## Providers

The following providers are used by this module:

- databricks (>= 1.128.0, < 2.0.0)

## Resources

The following resources are used by this module:

- [databricks_permissions.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) (resource)
- [databricks_sql_endpoint.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/sql_endpoint) (resource)

## Required Inputs

The following input variables are required:

### auto\_stop\_mins

Description: Minutes of inactivity before the warehouse stops. 0 disables auto stop.

Type: `number`

### cluster\_size

Description: Warehouse size, for example 2X-Small, Small, or Medium.

Type: `string`

### enable\_photon

Description: Run queries on the Photon engine.

Type: `bool`

### enable\_serverless\_compute

Description: Run the warehouse on serverless compute.

Type: `bool`

### max\_num\_clusters

Description: Maximum number of clusters the warehouse scales to.

Type: `number`

### min\_num\_clusters

Description: Minimum number of clusters the warehouse runs.

Type: `number`

### name

Description: SQL warehouse name.

Type: `string`

### warehouse\_type

Description: Warehouse type: CLASSIC or PRO.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### permissions

Description: Direct permissions on the warehouse. Each element names exactly one principal.

Type:

```hcl
list(object({
    permission_level       = string
    group_name             = optional(string)
    user_name              = optional(string)
    service_principal_name = optional(string)
  }))
```

Default: `[]`

### spot\_instance\_policy

Description: Spot policy: COST\_OPTIMIZED or RELIABILITY\_OPTIMIZED.

Type: `string`

Default: `null`

### tags

Description: Custom tags applied to the warehouse.

Type: `map(string)`

Default: `null`

## Outputs

The following outputs are exported:

### id

Description: SQL warehouse id.

### jdbc\_url

Description: JDBC URL of the warehouse.

### name

Description: SQL warehouse name.
<!-- END_TF_DOCS -->
