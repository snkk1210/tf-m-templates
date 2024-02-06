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

variable "ec2_instance_alarms" {
  type = list(object({
    ec2_instance_name = string
    ec2_instance_id   = string

    // EC2 CPUUtilization 
    ec2_cpuutilization_evaluation_periods = string
    ec2_cpuutilization_period             = string
    ec2_cpuutilization_statistic          = string
    ec2_cpuutilization_threshold          = string

    // EC2 StatusCheckFailed
    ec2_statuscheckfailed_evaluation_periods = string
    ec2_statuscheckfailed_period             = string
    ec2_statuscheckfailed_statistic          = string
    ec2_statuscheckfailed_threshold          = string
  }))
}