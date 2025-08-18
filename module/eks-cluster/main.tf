#############################################################################################################################################################################
#                                                                  EKS Cluster
#############################################################################################################################################################################

#EKS Cluster to deploy Face Rekognition Application

resource "aws_eks_cluster" "Face-Rekognition-cluster" {
  name = "Face-Rekognition-Cluster"
  version = var.eks-version
  role_arn = var.cluster-role-arn
  vpc_config {
    security_group_ids = [ var.cluster-sg, var.nodegroup-sg ]
    subnet_ids = [ var.private-subnet-1, var.private-subnet-2]
  }
  tags = {
    Name = "Face-Rekognition-Cluster"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}


#############################################################################################################################################################################
#                                                                  EKS Node Group
#############################################################################################################################################################################

#EKS Node Group for Face Rekognition Cluster

resource "aws_eks_node_group" "Face-Rekognition-nodegroup" {
  cluster_name = aws_eks_cluster.Face-Rekognition-cluster.name
  node_group_name = "Face-Rekognition-NodeGroup"
  node_role_arn = var.nodegroup-role-arn
  instance_types = [ var.instance-type ]
  subnet_ids = [ var.private-subnet-1, var.private-subnet-2 ]
  launch_template {
    id = var.launch-template-id
    version = "$Latest"
  }
  scaling_config {
    desired_size = "1"
    max_size = "2"
    min_size = "1"
  }
  tags = {
    Name = "Face-Rekogntion--NodeGroup"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}

#############################################################################################################################################################################
#                                                              EKS OpenID Connect Provider
#############################################################################################################################################################################

#EKS OpenID connect provider

data "aws_eks_cluster" "face-rekognition-cluster-data" {
  name = "Face-Rekognition-Cluster"
  depends_on = [ aws_eks_cluster.Face-Rekognition-cluster ]
}

resource "aws_iam_openid_connect_provider" "face-rekognition-openid-connect-provider" {
  url = data.aws_eks_cluster.face-rekognition-cluster-data.identity[0].oidc[0].issuer
  client_id_list = ["sts.amazonaws.com"]
}

#############################################################################################################################################################################
#                                                                   IAM Role
#############################################################################################################################################################################


resource "aws_iam_role" "oidc-role" {
  name = "Rekognition-IRSA-Role"
  description = "Creating this Role for OpenID Connect provider for Face Rekognition Cluster"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.face-rekognition-openid-connect-provider.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "oidc.eks.us-east-1.amazonaws.com/id/185752F27C472AC82CB874D688826212:sub": "system:serviceaccount:default:face-rekognition-sa"
          }
        }
      }
    ]
  })
}


#[Note: We might required to change the OIDC ARN each time for new creation on line 79] 

#############################################################################################################################################################################
#                                                                   IAM Policy
#############################################################################################################################################################################


#IAM Policy for OpenID connect provider

resource "aws_iam_policy" "rekognition-openid-connect-provider-policy" {
  name = "Rekognition-IRSA-Policy"
  description = "IAM Policy for for OpenID-Connect-Provider"
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
            "Sid": "DynamoDBGetItems",
            "Effect": "Allow",
            "Action": [
                "dynamodb:*"
            ],
            "Resource": "arn:aws:dynamodb:*:*:*"
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
        }
    ]

}  
EOF
  tags = {
    Name = "Rekognition-IRSA-Policy"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}


#############################################################################################################################################################################
#                                                                   IAM Role Policy Attachment
#############################################################################################################################################################################

resource "aws_iam_role_policy_attachment" "oidc-role-policy" {
  role = aws_iam_role.oidc-role.id
  policy_arn = aws_iam_policy.rekognition-openid-connect-provider-policy.arn
}