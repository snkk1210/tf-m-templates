/** 
# Variables for COMMON
*/
variable "sfx" {
  type    = string
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

variable "fargate_service_alarms" {
  type = list(object({
    fargate_name = string
    cluster_name = string

    // Fargate CPUUtilization
    fargate_cpuutilization_evaluation_periods = string
    fargate_cpuutilization_period             = string
    fargate_cpuutilization_statistic          = string
    fargate_cpuutilization_threshold          = string

    // Fargate MemoryUtilization
    fargate_memoryutilization_evaluation_periods = string
    fargate_memoryutilization_period             = string
    fargate_memoryutilization_statistic          = string
    fargate_memoryutilization_threshold          = string
    // Fargate RunningTaskCount
    fargate_runningtaskcount_evaluation_periods = string
    fargate_runningtaskcount_period             = string
    fargate_runningtaskcount_statistic          = string
    fargate_runningtaskcount_threshold          = string
    fargate_runningtaskcount_actions_enabled    = bool

    /** 
    # NOTE: ALB
    */
    alb_name = string
    alb_arn  = string

    // ALB HTTPCode_ELB_5XX_Count
    alb_httpcode_elb_5xx_count_evaluation_periods = string
    alb_httpcode_elb_5xx_count_period             = string
    alb_httpcode_elb_5xx_count_statistic          = string
    alb_httpcode_elb_5xx_count_threshold          = string
    // ALB HTTPCode_Target_5XX_Count
    alb_httpcode_target_5xx_count_evaluation_periods = string
    alb_httpcode_target_5xx_count_period             = string
    alb_httpcode_target_5xx_count_statistic          = string
    alb_httpcode_target_5xx_count_threshold          = string
  }))
}