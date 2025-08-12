#############################################################################################################################################################################
#                                                                       VPC
#############################################################################################################################################################################


resource "aws_vpc" "vpc" {
  cidr_block = var.vpc-cidr
  tags = {
    Name = "Face-Rekognition-VPC"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}

#############################################################################################################################################################################
#                                                                      Public Subnet
#############################################################################################################################################################################


resource "aws_subnet" "public-subnet-1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public-subnet-1-cidr
  map_public_ip_on_launch = true
  availability_zone = var.az1
  tags = {
    Name = "Face-Rekognition-Public-Subnet-1"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}


resource "aws_subnet" "public-subnet-2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public-subnet-2-cidr
  map_public_ip_on_launch = true
  availability_zone = var.az2
  tags = {
    Name = "Face-Rekognition-Public-Subnet-2"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}


#############################################################################################################################################################################
#                                                                     Private Subnet
#############################################################################################################################################################################

resource "aws_subnet" "private-subnet-1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private-subnet-1-cidr
  availability_zone = var.az1
  tags = {
    Name = "Face-Rekognition-Private-Subnet-1"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}


resource "aws_subnet" "private-subnet-2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private-subnet-2-cidr
  availability_zone = var.az2
  tags = {
    Name = "Face-Rekognition-Private-Subnet-2"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}

#############################################################################################################################################################################
#                                                                      Internet Gateway
#############################################################################################################################################################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Face-Rekognition-IGW"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}

#############################################################################################################################################################################
#                                                                       NAT Gateway
#############################################################################################################################################################################

resource "aws_eip" "elastic-ip-1" {
  tags = {
    Name = "Face-Rekognition-elastic-ip-1"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.elastic-ip-1.id
  subnet_id = aws_subnet.public-subnet-1.id
  tags = {
    Name = "Face-Rekognition-nat-gateway"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}

#############################################################################################################################################################################
#                                                                      Route Table
#############################################################################################################################################################################

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id
  route {
    gateway_id = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0"
  }
  tags = {
    Name = "Face-Rekognition-Public-Route-Table"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}


resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc.id
  route {
    gateway_id = aws_nat_gateway.nat-gateway.id
    cidr_block = "0.0.0.0/0"
  }
  tags = {
    Name = "Face-Rekognition-Private-Route-Table"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}

#############################################################################################################################################################################
#                                                                  Route Table Association
#############################################################################################################################################################################


resource "aws_route_table_association" "public-subnet-1-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id = aws_subnet.public-subnet-1.id
}

resource "aws_route_table_association" "public-subnet-2-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id = aws_subnet.public-subnet-2.id
}

resource "aws_route_table_association" "private-subnet-1-association" {
  route_table_id = aws_route_table.private-table.id
  subnet_id = aws_subnet.private-subnet-1.id
}

resource "aws_route_table_association" "private-subnet-2-association" {
  route_table_id = aws_route_table.private-table.id
  subnet_id = aws_subnet.private-subnet-2.id
}