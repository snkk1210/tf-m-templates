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