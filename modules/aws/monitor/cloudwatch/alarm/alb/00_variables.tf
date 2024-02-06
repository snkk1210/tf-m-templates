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

variable "alb_alarms" {
  type = list(object({
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