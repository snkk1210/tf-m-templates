variable "notify_sns_topic_arn" {
  type    = list(string)
  default = []
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