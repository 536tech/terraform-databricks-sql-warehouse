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

run "reject_blank_name" {
  command = plan
  variables {
    name = "  "
  }
  expect_failures = [var.name]
}

run "reject_missing_principal" {
  command = plan
  variables {
    permissions = [{ permission_level = "CAN_USE" }]
  }
  expect_failures = [var.permissions]
}

run "reject_multiple_principals" {
  command = plan
  variables {
    permissions = [{ permission_level = "CAN_USE", user_name = "user@example.com", group_name = "readers" }]
  }
  expect_failures = [var.permissions]
}

run "reject_blank_principal" {
  command = plan
  variables {
    permissions = [{ permission_level = "CAN_USE", group_name = " " }]
  }
  expect_failures = [var.permissions]
}

run "reject_invalid_permission" {
  command = plan
  variables {
    permissions = [{ permission_level = "INVALID", group_name = "readers" }]
  }
  expect_failures = [var.permissions]
}

run "reject_reversed_cluster_limits" {
  command = plan
  variables {
    min_num_clusters = 4
  }
  expect_failures = [databricks_sql_endpoint.this]
}

run "reject_group_owner" {
  command = plan
  variables {
    permissions = [{ permission_level = "IS_OWNER", group_name = "readers" }]
  }
  expect_failures = [var.permissions]
}

run "accept_provider_defaults" {
  command = plan
  variables {
    min_num_clusters          = null
    max_num_clusters          = null
    auto_stop_mins            = null
    warehouse_type            = null
    enable_photon             = null
    enable_serverless_compute = null
  }
}
