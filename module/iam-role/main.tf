##############################################################################################################################
#                                          Deploying IAM role 
##############################################################################################################################

#IAM role for Lambda to create Collection ID in Rekognition service

resource "aws_iam_role" "iam-role-lambda-to-create-collection-id" {
  name = "lambda-to-create-collection-id"
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
}

##############################################################################################################################
#                                          Deploying IAM Policy
##############################################################################################################################

#IAM Policy for Lambda to create Collection ID in Rekognition service

resource "aws_iam_policy" "iam-policy-lambda-to-create-collection-id" {
  name = "lambda-to-create-collection-id"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
      "Sid": "CollectingRekognition",
      "Effect": "Allow",
      "Action": [
        "rekognition:CreateCollection",
        "rekognition:DeleteCollection",
        "rekognition:ListCollections"
            ],
      "Resource": "*"
  },
  {
      "Sid": "CloudWatchLogGroups",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
            ],
      "Resource": "arn:aws:logs:*:*:*"
  }
    ]
}  
EOF
}

##############################################################################################################################
#                                          Role Policy Attachment
##############################################################################################################################

#Role and Policy attachment for lambda to create collection ID

resource "aws_iam_role_policy_attachment" "lambda-to-create-collection-id" {
  role = aws_iam_role.iam-role-lambda-to-create-collection-id.id
  policy_arn = aws_iam_policy.iam-policy-lambda-to-create-collection-id.arn
}


#############################################################################################################################
#############################################################################################################################

##############################################################################################################################
#                                          Deploying IAM role 
##############################################################################################################################

###### Creating IAM Role for Lambda function to collect faceprints and store it in DynamoDB

resource "aws_iam_role" "iam-role-putitems-in-dynamodb" {
  name = "lambda-to-store-faceprints-dynamodb"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
    "Effect": "Allow",
    "Principal": {
      "Service": "lambda.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
  }
  ]
}  
EOF
}

##############################################################################################################################
#                                          Deploying IAM Policy
##############################################################################################################################

#IAM Policy for Lambda to collect faceprints and store it in DynamoDB

resource "aws_iam_policy" "iam-policy-putitems-in-dynamodb" {
  name = "lambda-to-store-faceprints-dynamodb"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
  "Sid": "CloudWatchLoggroup",
  "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
            ],
      "Resource": "arn:aws:logs:*:*:*"
  },
  {
      "Sid": "Rekognitionindexface",
      "Effect": "Allow",
      "Action": [
        "rekognition:IndexFaces"
      ],
      "Resource": "arn:aws:rekognition:*:*:collection/*"
    },
    {
      "Sid": "DynamoDBputfaceprints",
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem"
      ],
      "Resource": "arn:aws:dynamodb:*:*:table/face-prints-table"
    },
    {
      "Sid": "S3fetchimages",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:HeadObject"
      ],
      "Resource": "arn:aws:s3:::face-rekognition-source-bucket-logesh/*"
    }
  ]
}  
EOF
}

##############################################################################################################################
#                                          Role Policy Attachment
##############################################################################################################################

#Role and Policy attachment for lambda to store faceprint in DynamoDB

resource "aws_iam_role_policy_attachment" "dynamodb-role-policy-attachment" {
  role = aws_iam_role.iam-role-putitems-in-dynamodb.id
  policy_arn = aws_iam_policy.iam-policy-putitems-in-dynamodb.arn
}



#############################################################################################################################
#############################################################################################################################

##############################################################################################################################
#                                          Deploying IAM role 
##############################################################################################################################

###### Creating IAM Role for EKS Cluster 
resource "aws_iam_role" "eks-cluster-role" {
  name = "eks-cluster-role"
  assume_role_policy = <<EOF
  {
  "Version": "2012-10-17",
  "Statement": [
  {
    "Effect": "Allow",
    "Principal": {
      "Service": "eks.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
  }
  ]
  }
EOF
}


##############################################################################################################################
#                                          Role Policy Attachment
##############################################################################################################################

#Role and Policy attachment for EKS

resource "aws_iam_role_policy_attachment" "eks-cluster-1" {
  role = aws_iam_role.eks-cluster-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks-cluster-2" {
  role = aws_iam_role.eks-cluster-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}


#############################################################################################################################
#############################################################################################################################

##############################################################################################################################
#                                          Deploying IAM role 
##############################################################################################################################

###### Creating IAM Role for EKS Node Group

resource "aws_iam_role" "eks-node-group" {
  name = "eks-node-group"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
    "Effect": "Allow",
    "Principal": {
      "Service": "ec2.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
  }
  ]
}  
EOF
}


##############################################################################################################################
#                                          Role Policy Attachment
##############################################################################################################################

#Role and Policy attachment for EKS Node Group
resource "aws_iam_role_policy_attachment" "eks-worker-node-policy" {
  role = aws_iam_role.eks-node-group.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role = aws_iam_role.eks-node-group.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_policy" {
  role = aws_iam_role.eks-node-group.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks-to-get-items-dynamoDB" {
 role =  aws_iam_role.eks-node-group.id
 policy_arn = aws_iam_policy.iam-policy-putitems-in-dynamodb.arn
}