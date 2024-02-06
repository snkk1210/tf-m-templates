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

variable "cloudfront_alarms" {
  type = list(object({

    /** 
    # CloudFront
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