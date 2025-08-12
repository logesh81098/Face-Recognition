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