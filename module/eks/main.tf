#################################################################################################################################################
#                                                   Deploying EKS Cluster
#################################################################################################################################################

#EKS cluster to run the application 

resource "aws_eks_cluster" "Face-rekognition" {
  name = "Face-rekognition-EKS"
  role_arn = var.eks-role-arn
  vpc_config {
    subnet_ids = [ var.subnet-1, var.subnet-2 ]
  }
  tags = {
    Name = "Face-rekognition-EKS"
  }
}


#################################################################################################################################################
#                                                 Deploying EKS Node Group
#################################################################################################################################################

resource "aws_eks_node_group" "Face-rekognition-node-group" {
  cluster_name = aws_eks_cluster.Face-rekognition.name
  node_group_name = "Face-rekognition-node-group"
  node_role_arn = var.eks-node-group-arn
  subnet_ids = [ var.subnet-1, var.subnet-2 ]
  scaling_config {
    max_size = "2"
    desired_size = "1"
    min_size = "1"
  }
  instance_types = [ "t3.medium"]
  tags = {
    Name = "Face-rekognition-node-group"
  }
}