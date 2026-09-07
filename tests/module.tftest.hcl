mock_provider "databricks" {}

variables {

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

run "documented_example" {
  command = apply

  assert {
    condition     = databricks_sql_endpoint.this.name == var.name
    error_message = "The resource must preserve its configured name."
  }

  assert {
    condition     = length(databricks_permissions.this) == 1
    error_message = "Configured access must have stable resource addresses."
  }
}

run "without_access" {
  command = plan

  variables {
    permissions = []
  }

  assert {
    condition     = length(databricks_permissions.this) == 0
    error_message = "Empty access must omit the access resources."
  }
}
