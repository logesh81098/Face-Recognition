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