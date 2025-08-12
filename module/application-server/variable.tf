variable "ami-id" {
  default = "ami-0953476d60561c955"
}

variable "instance-type" {
  default = "t3.medium"
}

variable "subnet-id" {
  default = {}
}

variable "keypair" {
  default = {}
}

variable "Instance-profile" {
  default = {}
}

variable "Application-server-SG" {
  default = {}
}

variable "root-volume-type" {
  default = "gp3"
}

variable "root-volume-size" {
  default = "12"
}