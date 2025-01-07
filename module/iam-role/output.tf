output "collection-id-role" {
  value = aws_iam_role.iam-role-lambda-to-create-collection-id.arn
}

output "faceprints" {
  value = aws_iam_role.iam-role-putitems-in-dynamodb.arn
}