output "collectionid-role-arn" {
  value = aws_iam_role.collectionid-role.arn
}

output "faceprints-role-arn" {
  value = aws_iam_role.faceprints-role.arn
}

output "application-server-instance-profile" {
  value = aws_iam_instance_profile.application-server-instance-profile.name
}

output "cluster-role-arn" {
  value = aws_iam_role.eks-cluster-role.arn
}

output "nodegroup-role-arn" {
  value = aws_iam_role.eks-nodegroup-role.arn
}