output "collection-id-role" {
  value = aws_iam_role.iam-role-lambda-to-create-collection-id.arn
}

output "faceprints" {
  value = aws_iam_role.iam-role-putitems-in-dynamodb.arn
}


output "eks-role-arn" {
  value = aws_iam_role.eks-cluster-role.arn
}

output "eks-node-group-role-arn" {
  value = aws_iam_role.eks-node-group.arn
}