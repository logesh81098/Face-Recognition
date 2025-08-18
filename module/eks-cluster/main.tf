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