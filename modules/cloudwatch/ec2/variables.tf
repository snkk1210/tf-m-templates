variable "common" {
  type = object({
    project     = string
    environment = string
  })

  default = {
    environment = ""
    project     = ""
  }
}

variable "cloudwatch_alarm_notify_sns_topic_arn" {
  type = string
}

variable "ec2_instance_alarm" {
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