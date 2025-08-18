module "s3" {
  source = "./module/s3"
  faceprints-function-arn = module.lambda-function.faceprints-function-arn
}

module "iam" {
  source = "./module/iam"
}

module "lambda-function" {
  source = "./module/lambda-function"
  rekognition-collectionid-role-arn = module.iam.collectionid-role-arn
  rekognition-faceprints-role-arn = module.iam.faceprints-role-arn
  source-s3-bucket-arn = module.s3.source-s3-bucket-arn
}

module "dynamodb-table" {
  source = "./module/dynamodb-table"
}

module "vpc" {
  source = "./module/vpc"
}

module "security-group" {
  source = "./module/security-group"
  vpc-id = module.vpc.vpc-id
}

module "key-pair" {
  source = "./module/key-pair"
}

module "application-server" {
  source = "./module/application-server"
  keypair = module.key-pair.keypair
  Instance-profile = module.iam.application-server-instance-profile
  Application-server-SG = module.security-group.application-server-sg
  subnet-id = module.vpc.public-subnet-1
}

module "launch-template" {
  source = "./module/launch-template"
  nodegroup-sg = module.security-group.nodegroup-sg
  application-sg = module.security-group.application-server-sg
  key-name = module.key-pair.keypair
}

module "eks-cluster" {
  source = "./module/eks-cluster"
  cluster-role-arn = module.iam.cluster-role-arn
  nodegroup-sg = module.security-group.nodegroup-sg
  cluster-sg = module.security-group.cluster-sg
  private-subnet-1 = module.vpc.private-subnet-1
  private-subnet-2 = module.vpc.private-subnet-2
  launch-template-id = module.launch-template.launch-template-id
  nodegroup-role-arn = module.iam.nodegroup-role-arn
}