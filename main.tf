module "s3" {
  source = "./module/s3"
}

module "iam-role" {
  source = "./module/iam-role"
}

module "lambda-function" {
  source = "./module/lambda-funtion"
  lambda-to-create-collection-id = module.iam-role.collection-id-role
  lambda-to-store-faceprints = module.iam-role.faceprints
}

module "dynamodb-table" {
  source = "./module/dynamodb-table"
}