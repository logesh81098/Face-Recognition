variable "eks-version" {
  default = "1.33"
}

variable "cluster-role-arn" {
  default = {}
}

variable "cluster-sg" {
  default = {}
}

variable "nodegroup-sg" {
  default = {}
}

variable "private-subnet-1" {
  default = {}
}

variable "private-subnet-2" {
  default = {}
}

variable "launch-template-id" {
  default = {}
}

variable "nodegroup-role-arn" {
  default = {}
}

variable "instance-type" {
  default = "t3.medium"
}