variable "common" {
  type = object({
    project     = string
    environment = string
    region      = string
  })

  default = {
    project     = ""
    environment = ""
    region      = ""
  }
}

variable "s3_bucket_name" {
  type = string
}

variable "s3_bucket_region" {
  type = string
}

variable "lambda_timezone" {
  type    = string
  default = "Asia/Tokyo"
}

variable "reserved_concurrent_executions" {
  type    = number
  default = -1
}