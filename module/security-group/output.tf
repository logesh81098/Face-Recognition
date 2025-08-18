output "application-server-sg" {
  value = aws_security_group.Application-server-sg.id
}

output "nodegroup-sg" {
  value = aws_security_group.eks-node-group-sg.id
}