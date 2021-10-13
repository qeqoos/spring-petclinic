variable "profile" {
  type    = string
  default = "default"
}

variable "region-default" {
  type    = string
  default = "eu-west-1"
}

variable "instance-type" {
  type    = string
  default = "t2.micro"
}

variable "ami" {
  type    = string
  default = "ami-05cd35b907b4ffe77"
}