module "s3" {
  source = "./module/s3"
  faceprints-lambda-arn = module.lambda-function.faceprints-lambda-arn
}

module "iam-role" {
  source = "./module/iam-role"
}

module "lambda-function" {
  source = "./module/lambda-funtion"
  lambda-to-create-collection-id = module.iam-role.collection-id-role
  lambda-to-store-faceprints = module.iam-role.faceprints
  source-bucket-arn = module.s3.bucket-arn
}

module "dynamodb-table" {
  source = "./module/dynamodb-table"
}

module "vpc" {
  source = "./module/vpc"
  
}

module "eks" {
  source = "./module/eks"
  eks-role-arn = module.iam-role.eks-role-arn
  eks-node-group-arn = module.iam-role.eks-node-group-role-arn
  subnet-1 = module.vpc.subnet-1
  subnet-2 = module.vpc.subnet-2
}