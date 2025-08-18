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

#############################################################################################################################################################################
#                                                                     Security Group
#############################################################################################################################################################################

#Security Group for EKS Cluster

resource "aws_security_group" "eks-cluster-sg" {
  name = "Face-Rekognition-Cluster-SG"
  description = "Security Group for EKS Cluster"
  vpc_id = var.vpc-id

  ingress {
    from_port = var.api-server
    to_port = var.api-server
    protocol = "tcp"
    cidr_blocks = [ var.anywhere-ip ]
    description = "Ingress rule to communicate with API Server"
  }

  ingress {
    from_port = var.application-port
    to_port = var.application-port
    protocol = "tcp"
    cidr_blocks = [ var.anywhere-ip ]
    description = "Ingress rule to access application"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ var.anywhere-ip ]
    description = "Allow connection from anywhere"
  }

  tags = {
    Name = "Face-Rekognition-Cluster-SG"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
    "kubernetes.io/cluster/Face-Rekognition-Cluster" = "owned"
    "eks-cluster-name" = "Face-Rekognition-EKS-Cluster"
  }
}

#############################################################################################################################################################################
#                                                                     Security Group
#############################################################################################################################################################################

#Security Group for EKS Node Group

resource "aws_security_group" "eks-node-group-sg" {
  name = "Face-Rekognition-NodeGroup-SG"
  description = "Security Group for Face Rekognition Cluster Node Group"
  vpc_id = var.vpc-id

  ingress {
    from_port = var.api-server
    to_port = var.api-server
    protocol = "tcp"
    cidr_blocks = [ var.anywhere-ip ]
    description = "Ingress rule to communicate with API Server"
  }

  ingress {
    from_port = var.application-port
    to_port = var.application-port
    protocol = "tcp"
    cidr_blocks = [ var.anywhere-ip ]
    description = "Ingress rule to allow application port"
  }

  ingress {
    from_port = var.SSH-port
    to_port = var.SSH-port
    protocol = "tcp"
    cidr_blocks = [ var.anywhere-ip ]
    description = "Ingress Rule for SSH Port"
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [ aws_security_group.eks-cluster-sg.id ]
    description = "Ingress rule to allow all communication from EKS Cluster SG"
  }

  ingress {
    from_port = "0"
    to_port = "65535"
    protocol = "tcp"
    self = true
    description = "Allow All Traffic from self"

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ var.anywhere-ip ]
    description = "Egress rule to allow all port and all ip connection from anywhere"
  }

  tags = {
    Name = "Face-Rekognition-NodeGroup-SG"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
    "kubernetes.io/cluster/Face-Rekognition-Cluster" = "owned"
    "eks-cluster-name" = "Face-Rekognition-EKS-Cluster"
  }
}