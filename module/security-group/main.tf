#############################################################################################################################################################################
#                                                                     Security Group
#############################################################################################################################################################################

resource "aws_security_group" "Application-server-sg" {
  name = "Application-Server-SG"
  description = "Security Group for Application Server"
  vpc_id = var.vpc-id

  ingress {
    from_port = var.application-port
    to_port = var.application-port
    cidr_blocks = [ var.anywhere-ip ]
    protocol = "tcp"
    description = "Ingress Rule for Application port"
  }

  ingress {
    from_port = var.SSH-port
    to_port = var.SSH-port
    cidr_blocks = [ var.anywhere-ip ]
    protocol = "tcp"
    description = "Ingress Rule for SSH Port"
  }

  ingress {
    from_port = var.Jenkins-Port
    to_port = var.Jenkins-Port
    cidr_blocks = [ var.anywhere-ip ]
    protocol = "tcp"
    description = "Ingress Rule for Jenkins Port"
  }

  ingress {
    from_port = var.HTTP-Port
    to_port = var.HTTP-Port
    cidr_blocks = [ var.anywhere-ip ]
    protocol = "tcp"
    description = "Ingress Rule for HTTP Port"
  }

  ingress {
    from_port = var.HTTPS-Port
    to_port = var.HTTPS-Port
    cidr_blocks = [ var.anywhere-ip ]
    protocol = "tcp"
    description = "Ingress Rule for HTTPS Port"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ var.anywhere-ip ]
    description = "Allow anyport from anywhere IP address"
  }

  tags = {
    Name = "Application-Server-SG"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}