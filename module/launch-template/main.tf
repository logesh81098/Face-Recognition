#############################################################################################################################################################################
#                                                                  Launch Template
#############################################################################################################################################################################

# Launch Template for EKS NodeGroup

resource "aws_launch_template" "eks-launch-template" {
  name = "Face-Rekognition-launch-template"
  vpc_security_group_ids = [ var.application-sg, var.nodegroup-sg ]
  key_name = var.key-name
  tag_specifications {
    resource_type = "instance"
        tags = {
            Name = "Face-Rekogntion-WorkerNodes"
            Project = "Recognizing-faces-using-AWS-Rekognition-service"
        }
    }
    tags = {
      Name = "Face-Rekogntion-WorkerNodes"
      Project = "Recognizing-faces-using-AWS-Rekognition-service"
      "eks:cluster-name" = "Face-Rekognition-Cluster"
      "eks-nodegroup-name" = "Face-Rekognition-NodeGroup"
    }
}