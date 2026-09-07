variable "name" {
  description = "SQL warehouse name."
  type        = string
}

variable "cluster_size" {
  description = "Warehouse size, for example 2X-Small, Small, or Medium."
  type        = string
}

variable "min_num_clusters" {
  description = "Minimum number of clusters the warehouse runs."
  type        = number
}

variable "max_num_clusters" {
  description = "Maximum number of clusters the warehouse scales to."
  type        = number
}

variable "auto_stop_mins" {
  description = "Minutes of inactivity before the warehouse stops. 0 disables auto stop."
  type        = number
}

variable "warehouse_type" {
  description = "Warehouse type: CLASSIC or PRO."
  type        = string
}

variable "enable_photon" {
  description = "Run queries on the Photon engine."
  type        = bool
}

variable "enable_serverless_compute" {
  description = "Run the warehouse on serverless compute."
  type        = bool
}

variable "spot_instance_policy" {
  description = "Spot policy: COST_OPTIMIZED or RELIABILITY_OPTIMIZED."
  type        = string
  default     = null
}

variable "tags" {
  description = "Custom tags applied to the warehouse."
  type        = map(string)
  default     = null
}

variable "permissions" {
  description = "Direct permissions on the warehouse. Each element names exactly one principal."

  type = list(object({
    permission_level       = string
    group_name             = optional(string)
    user_name              = optional(string)
    service_principal_name = optional(string)
  }))

  default = []
}
