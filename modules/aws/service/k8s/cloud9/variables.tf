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

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "image_id" {
  type    = string
  default = "amazonlinux-2-x86_64"
}