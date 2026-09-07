output "id" {
  description = "SQL warehouse id."
  value       = databricks_sql_endpoint.this.id
}

output "name" {
  description = "SQL warehouse name."
  value       = databricks_sql_endpoint.this.name
}

output "jdbc_url" {
  description = "JDBC URL of the warehouse."
  value       = databricks_sql_endpoint.this.jdbc_url
}
