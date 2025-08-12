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