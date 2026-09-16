variable "name" {
  description = "SQL warehouse name."
  type        = string
  nullable    = false

  validation {
    condition     = try(length(trimspace(var.name)) > 0, false)
    error_message = "name must not be empty or blank."
  }
}

variable "cluster_size" {
  description = "Warehouse size, for example 2X-Small, Small, or Medium."
  type        = string
  nullable    = false

  validation {
    condition     = try(length(trimspace(var.cluster_size)) > 0, false)
    error_message = "cluster_size must not be empty or blank."
  }
}

variable "min_num_clusters" {
  description = "Minimum number of clusters the warehouse runs."
  type        = number

  validation {
    condition     = var.min_num_clusters == null ? true : try(var.min_num_clusters >= 1 && floor(var.min_num_clusters) == var.min_num_clusters, false)
    error_message = "min_num_clusters must be an integer of at least 1."
  }
}

variable "max_num_clusters" {
  description = "Maximum number of clusters the warehouse scales to."
  type        = number

  validation {
    condition     = var.max_num_clusters == null ? true : try(var.max_num_clusters >= 1 && floor(var.max_num_clusters) == var.max_num_clusters, false)
    error_message = "max_num_clusters must be an integer of at least 1."
  }
}

variable "auto_stop_mins" {
  description = "Minutes of inactivity before the warehouse stops. 0 disables auto stop."
  type        = number

  validation {
    condition     = var.auto_stop_mins == null ? true : try(var.auto_stop_mins >= 0 && floor(var.auto_stop_mins) == var.auto_stop_mins, false)
    error_message = "auto_stop_mins must be an integer of at least 0."
  }
}

variable "warehouse_type" {
  description = "Warehouse type: CLASSIC or PRO."
  type        = string

  validation {
    condition     = var.warehouse_type == null ? true : contains(["CLASSIC", "PRO"], var.warehouse_type)
    error_message = "warehouse_type must be CLASSIC or PRO."
  }
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
  validation {
    condition     = var.spot_instance_policy == null ? true : contains(["COST_OPTIMIZED", "RELIABILITY_OPTIMIZED"], var.spot_instance_policy)
    error_message = "spot_instance_policy must be COST_OPTIMIZED or RELIABILITY_OPTIMIZED."
  }
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

  default  = []
  nullable = false

  validation {
    condition = try(alltrue([for permission in var.permissions :
      length([for principal in [permission.group_name, permission.user_name, permission.service_principal_name] :
        principal if principal != null
      ]) == 1 &&
      alltrue([for principal in [permission.group_name, permission.user_name, permission.service_principal_name] :
        principal == null ? true : length(trimspace(principal)) > 0
      ]) && contains(["CAN_USE", "CAN_MONITOR", "CAN_MANAGE", "CAN_VIEW", "IS_OWNER"], permission.permission_level)
    ]), false)
    error_message = "Each permission needs exactly one nonblank principal and a supported level: CAN_USE, CAN_MONITOR, CAN_MANAGE, CAN_VIEW, IS_OWNER."
  }
  validation {
    condition = alltrue([for permission in var.permissions :
      permission.permission_level != "IS_OWNER" || permission.group_name == null
    ]) && length([for permission in var.permissions : permission if permission.permission_level == "IS_OWNER"]) <= 1
    error_message = "A warehouse can have at most one explicit owner; a group cannot own a warehouse."
  }
}
