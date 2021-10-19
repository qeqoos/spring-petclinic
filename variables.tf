variable "profile" {
  type    = string
  default = "default"
}

variable "region-default" {
  type    = string
  # default = "us-east-1"
  default = "eu-west-1"
}

variable "instance-type" {
  type    = string
  default = "t2.micro"
  # default = "t2.small"
}

variable "ami" {
  type    = string
  default = "ami-05cd35b907b4ffe77"
  # default = "ami-02e136e904f3da870"
}