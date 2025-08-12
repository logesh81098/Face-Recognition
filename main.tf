module "s3" {
  source = "./module/s3"
}

module "iam" {
  source = "./module/iam"
}

module "lambda-function" {
  source = "./module/lambda-function"
  rekognition-collectionid-role-arn = module.iam.collectionid-role-arn
  rekognition-faceprints-role-arn = module.iam.faceprints-role-arn
}

module "dynamodb-table" {
  source = "./module/dynamodb-table"
}