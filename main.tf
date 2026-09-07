locals {
  tags = var.tags == null ? {} : var.tags
}

resource "databricks_sql_endpoint" "this" {
  name                      = var.name
  cluster_size              = var.cluster_size
  min_num_clusters          = var.min_num_clusters
  max_num_clusters          = var.max_num_clusters
  auto_stop_mins            = var.auto_stop_mins
  warehouse_type            = var.warehouse_type
  enable_photon             = var.enable_photon
  enable_serverless_compute = var.enable_serverless_compute
  spot_instance_policy      = var.spot_instance_policy

  dynamic "tags" {
    for_each = length(local.tags) > 0 ? [local.tags] : []

    content {
      dynamic "custom_tags" {
        for_each = tags.value

        content {
          key   = custom_tags.key
          value = custom_tags.value
        }
      }
    }
  }
}

resource "databricks_permissions" "this" {
  count = length(var.permissions) > 0 ? 1 : 0

  sql_endpoint_id = databricks_sql_endpoint.this.id

  dynamic "access_control" {
    for_each = var.permissions

    content {
      permission_level       = access_control.value.permission_level
      group_name             = access_control.value.group_name
      user_name              = access_control.value.user_name
      service_principal_name = access_control.value.service_principal_name
    }
  }
}
