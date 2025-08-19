#############################################################################################################################################################################
#                                                                      IAM Role
#############################################################################################################################################################################

#IAM Role for Lambda Function to create CollectionID in AWS Rekognition service

resource "aws_iam_role" "collectionid-role" {
  name = "Rekognition-CollectionID-Role"
  description = "IAM Role for Lambda Function to create CollectionID in AWS Rekognition service"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            }
        }
    ]
}
EOF
  tags = {
    Name = "Rekognition-CollectionID-Role"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}


#############################################################################################################################################################################
#                                                                      IAM Policy
#############################################################################################################################################################################

#IAM Policy for Lambda Function to create CollectionID in AWS Rekognition service

resource "aws_iam_policy" "collectionid-policy" {
  name = "Rekognition-CollectionID-Policy"
  description = "IAM Policy for Lambda Function to create CollectionID in AWS Rekognition service"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CloudWatchLogGroup",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Sid": "RekognitionCollectionID",
            "Effect": "Allow",
            "Action": [
                "rekognition:CreateCollection",
                "rekognition:DeleteCollection",
                "rekognition:ListCollections"
            ],
            "Resource": "*"
        }
    ]
}  
EOF
  tags = {
    Name = "Rekognition-CollectionID-Policy"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}

#############################################################################################################################################################################
#                                                                  Role & Policy Attachment
#############################################################################################################################################################################

resource "aws_iam_role_policy_attachment" "collectionid" {
  role = aws_iam_role.collectionid-role.id
  policy_arn = aws_iam_policy.collectionid-policy.arn
}

#############################################################################################################################################################################
#                                                                      IAM Role
#############################################################################################################################################################################

#IAM Role for Lambda Function to Generate Faceprints using AWS Rekognition Service

resource "aws_iam_role" "faceprints-role" {
  name = "Rekognition-Faceprints-Role"
  description = "IAM Role for Lambda Function to Generate Faceprints using AWS Rekognition Service"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            }
        }
    ]
}  
EOF
  tags = {
    Name = "Rekognition-Faceprints-Role"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}


#############################################################################################################################################################################
#                                                                      IAM Policy
#############################################################################################################################################################################

#IAM Role for Lambda Function to Generate Faceprints using AWS Rekognition Service

resource "aws_iam_policy" "faceprints-policy" {
  name = "Rekognition-Faceprints-Policy"
  description = "IAM Role for Lambda Function to Generate Faceprints using AWS Rekognition Service"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CloudWatchLogGroup",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Sid": "GetObjectFromS3Bucket",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:HeadObject"
            ],
            "Resource": "arn:aws:s3:::face-rekognition-source-bucket/*"
        },
        {
            "Sid": "IndexFacesUsingRekognition",
            "Effect": "Allow",
            "Action": [
                "rekognition:IndexFaces"
            ],
            "Resource": "arn:aws:rekognition:*:*:collection/*"
        },
        {
            "Sid": "PutFacePrintsInDynamoDBTable",
            "Effect": "Allow",
            "Action": [
                "dynamodb:PutItem"
            ],
            "Resource": "arn:aws:dynamodb:*:*:table/Faceprints-Table"
        }
    ]
}
EOF
  tags = {
    Name = "Rekognition-Faceprints-Policy"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}


#############################################################################################################################################################################
#                                                                  Role & Policy Attachment
#############################################################################################################################################################################

resource "aws_iam_role_policy_attachment" "faceprints" {
  role = aws_iam_role.faceprints-role.id
  policy_arn = aws_iam_policy.faceprints-policy.arn
}

#############################################################################################################################################################################
#                                                                      IAM Role
#############################################################################################################################################################################

#IAM Role for Application Server

resource "aws_iam_role" "application-server-role" {
  name = "Rekognition-Application-Server-Role"
  description = "IAM Role for Application Server"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            }
        }
    ]
}
EOF
  tags = {
    Name = "Rekognition-Application-Server-Role"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}


#############################################################################################################################################################################
#                                                                      IAM Policy
#############################################################################################################################################################################

#IAM Policy for Application Server

resource "aws_iam_policy" "application-server-policy" {
  name = "Rekognition-Application-Server-Policy"
  description = "IAM Policy for Application Server"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CloudWatchLogGroup",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Sid": "RekognitionIndexFace",
            "Effect": "Allow",
            "Action": [
                "rekognition:*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "CompareFacePrintsFromDynamoDBTable",
            "Effect": "Allow",
            "Action": [
                "dynamodb:*"
            ],
            "Resource": "arn:aws:dynamodb:*:*:table/Faceprints-Table"
        },
        {
            "Sid": "S3PutSourceImage",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:PutObject",
                "s3:GetObject",
                "s3:HeadObject"
              ],
            "Resource": [
                "arn:aws:s3:::face-rekognition-source-bucket/*",
                "arn:aws:s3:::face-rekognition-source-bucket"
              ]
          },
          {
            "Sid": "Describe EKS Cluster",
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster"
              ],
            "Resource": "*"
          }
    ]
}
EOF

  tags = {
    Name = "Rekognition-Application-Server-Policy"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}

#############################################################################################################################################################################
#                                                                  Role & Policy Attachment
#############################################################################################################################################################################

resource "aws_iam_role_policy_attachment" "application-server" {
  role = aws_iam_role.application-server-role.id
  policy_arn = aws_iam_policy.application-server-policy.arn
}

#############################################################################################################################################################################
#                                                                  IAM Instance Profile
#############################################################################################################################################################################

resource "aws_iam_instance_profile" "application-server-instance-profile" {
  role = aws_iam_role.application-server-role.id
  name = "-Rekognition-Application-Server-Instance-Profile"
}

#############################################################################################################################################################################
#                                                                      IAM Role
#############################################################################################################################################################################

#IAM Role for EKS Cluster

resource "aws_iam_role" "eks-cluster-role" {
  name = "Rekogntition-Cluster-Role"
  description = "IAM Role for Face Rekognition EKS Cluster"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "eks.amazonaws.com"
            }
        }
    ]
}  
EOF
  tags = {
    Name = "Rekogntition-Cluster-Role"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}


#############################################################################################################################################################################
#                                                                  Role & Policy Attachment
#############################################################################################################################################################################

resource "aws_iam_role_policy_attachment" "cluster-application-policy" {
  role = aws_iam_role.eks-cluster-role.id
  policy_arn = aws_iam_policy.application-server-policy.arn
}


resource "aws_iam_role_policy_attachment" "compute-policy" {
  role = aws_iam_role.eks-cluster-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSComputePolicy"
}

resource "aws_iam_role_policy_attachment" "storage-policy" {
  role = aws_iam_role.eks-cluster-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"
}

resource "aws_iam_role_policy_attachment" "cni-policy" {
  role = aws_iam_role.eks-cluster-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "cluster-policy" {
  role = aws_iam_role.eks-cluster-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "loadbalancing-policy" {
  role = aws_iam_role.eks-cluster-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
}

resource "aws_iam_role_policy_attachment" "network-policy" {
  role = aws_iam_role.eks-cluster-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
}


#############################################################################################################################################################################
#                                                                      IAM Role
#############################################################################################################################################################################

#IAM Role for EKS Node Group

resource "aws_iam_role" "eks-nodegroup-role" {
  name = "Rekognition-NodeGroup-Role"
  description = "IAM Role created for Face Rekognition NodeGroup"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            }
        }
    ]
}  
EOF
  tags = {
    Name = "Rekognition-NodeGroup-Role"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}


#############################################################################################################################################################################
#                                                                  Role & Policy Attachment
#############################################################################################################################################################################


resource "aws_iam_role_policy_attachment" "node-application-policy" {
  role = aws_iam_role.eks-nodegroup-role.id
  policy_arn = aws_iam_policy.application-server-policy.arn
}


resource "aws_iam_role_policy_attachment" "worker-node-policy" {
  role = aws_iam_role.eks-nodegroup-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "container-registry-policy" {
  role = aws_iam_role.eks-nodegroup-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}

resource "aws_iam_role_policy_attachment" "nodegroup-cni-policy" {
  role = aws_iam_role.eks-nodegroup-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
