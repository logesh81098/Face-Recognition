##################################################################################################################################################
#                                                  Creating VPC
##################################################################################################################################################

#VPC for Kubernetes
resource "aws_vpc" "Face-rekognition-vpc" {
  cidr_block = var.vpc-cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "Face-rekognition-vpc"
  }
}


##################################################################################################################################################
#                                                  Creating Subnets
##################################################################################################################################################

resource "aws_subnet" "public-subnet-1" {
  cidr_block = var.public-subnet-1-cidr
  availability_zone = var.az-1
  vpc_id = aws_vpc.Face-rekognition-vpc.id
  tags = {
    Name = "Face-rekognition-public-subnet-1"
  }
}


resource "aws_subnet" "public-subnet-2" {
  cidr_block = var.public-subnet-2-cidr
  availability_zone = var.az-2
  vpc_id = aws_vpc.Face-rekognition-vpc.id
  tags = {
    Name = "Face-rekognition-public-subnet-2"
  }
}


##################################################################################################################################################
#                                                  Creating Internet Gateway
##################################################################################################################################################

resource "aws_internet_gateway" "Face-rekognition-igw" {
  vpc_id = aws_vpc.Face-rekognition-vpc.id
  tags = {
    Name = "Face-rekognition-igw"
  }
}



##################################################################################################################################################
#                                                    Creating Route table
##################################################################################################################################################
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.Face-rekognition-vpc.id
  route {
    gateway_id = aws_internet_gateway.Face-rekognition-igw.id
    cidr_block = "0.0.0.0/0"
  }
  tags = {
    Name = "Face-rekognition-public-route-table"
  }
}



##################################################################################################################################################
#                                                  Route table Association
##################################################################################################################################################
resource "aws_route_table_association" "public-subnet-1-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id = aws_subnet.public-subnet-1.id
}

resource "aws_route_table_association" "public-subnet-2-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id = aws_subnet.public-subnet-2.id
}

