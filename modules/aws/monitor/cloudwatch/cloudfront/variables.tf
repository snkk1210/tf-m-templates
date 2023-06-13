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

variable "cloudfront_alarm" {
  type = list(object({

    /** 
    # NOTE: CloudFront
    */
    cloudfront_name = string
    cloudfront_id   = string

    // CloudFront 5xxErrorRate
    cloudfront_5xxerrorrate_evaluation_periods = string
    cloudfront_5xxerrorrate_period             = string
    cloudfront_5xxerrorrate_statistic          = string
    cloudfront_5xxerrorrate_threshold          = string

  }))
}