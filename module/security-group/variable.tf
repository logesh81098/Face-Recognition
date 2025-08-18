variable "vpc-id" {
  default = {}
}

variable "application-port" {
  default = "81"
}

variable "anywhere-ip" {
  default = "0.0.0.0/0"
}

variable "SSH-port" {
  default = "22"
}

variable "HTTP-Port" {
  default = "80"
}

variable "HTTPS-Port" {
  default = "443"
}

variable "Jenkins-Port" {
  default = "8080"
}

variable "api-server" {
  default = "443"
}