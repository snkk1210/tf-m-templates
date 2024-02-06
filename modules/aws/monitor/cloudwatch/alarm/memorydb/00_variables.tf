/** 
# Variables for COMMON
*/
variable "sfx" {
  type = string
  default = "01"
}

/** 
# Variables for CloudWatch
*/
variable "action" {
  type = object({
    alarm        = list(string)
    ok           = list(string)
    insufficient = list(string)
  })

  default = {
    alarm        = []
    ok           = []
    insufficient = []
  }
}

variable "memorydb_cluster_alarms" {
  type = list(object({
    memorydb_cluster_name = string

    // MemoryDB for Redis CPUUtilization 
    memorydb_cpuutilization_evaluation_periods = string
    memorydb_cpuutilization_period             = string
    memorydb_cpuutilization_statistic          = string
    memorydb_cpuutilization_threshold          = string

    // MemoryDB for Redis FreeableMemory
    memorydb_freeablememory_evaluation_periods = string
    memorydb_freeablememory_period             = string
    memorydb_freeablememory_statistic          = string
    memorydb_freeablememory_threshold          = string

    // MMemoryDB for Redis SwapUsage
    memorydb_swapusage_evaluation_periods = string
    memorydb_swapusage_period             = string
    memorydb_swapusage_statistic          = string
    memorydb_swapusage_threshold          = string

    // MemoryDB for Redis Evictions
    memorydb_evictions_evaluation_periods = string
    memorydb_evictions_period             = string
    memorydb_evictions_statistic          = string
    memorydb_evictions_threshold          = string
  }))
}