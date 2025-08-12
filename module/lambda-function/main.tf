#############################################################################################################################################################################
#                                                               Convert Python file to Zip file
#############################################################################################################################################################################
data "archive_file" "collectionid-python-to-zip" {
  type = "zip"
  source_dir = "module/lambda-function"
  output_path = "module/lambda-function/rekognition-collection-id.zip"
}


#############################################################################################################################################################################
#                                                                      Lambda Function
#############################################################################################################################################################################

#Lambda function to create CollectionID in AWS Rekognition Service using AWS CLI


resource "aws_lambda_function" "rekognition-collectionid" {
  function_name = "Rekognition-CollectionID"
  description = "Lambda function to create CollectionID in AWS Rekognition Service using AWS CLI"
  filename = "module/lambda-function/rekognition-collection-id.zip"
  role = var.rekognition-collectionid-role-arn
  handler = "rekognition-collection-id.lambda_handler"
  runtime = "python3.8"
  timeout = 20
  tags = {
    Name = "Rekognition-CollectionID"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}


#############################################################################################################################################################################
#                                                                Invoke Lambda Function
#############################################################################################################################################################################

#Invoke Lambda function

resource "aws_lambda_invocation" "collectionid-invoke" {
  function_name = aws_lambda_function.rekognition-collectionid.function_name
  input = jsonencode({
    "collection_id" = "face-rekognition-collection"
  })
}

#############################################################################################################################################################################
#                                                               Convert Python file to Zip file
#############################################################################################################################################################################

data "archive_file" "faceprints" {
  type = "zip"
  source_dir = "module/lambda-function"
  output_path = "module/lambda-function/rekognition-faceprints.zip"
}


#############################################################################################################################################################################
#                                                                      Lambda Function
#############################################################################################################################################################################

#Lambda function to Generate FacePrints using AWS Rekognition Service and store it in DynamoDb Table

resource "aws_lambda_function" "faceprints" {
  function_name = "Rekognition-Faceprints"
  description = "Lambda function to Generate FacePrints using AWS Rekognition Service and store it in DynamoDb Table"
  filename = "module/lambda-function/rekognition-faceprints.zip"
  role = var.rekognition-faceprints-role-arn
  handler = "rekognition-faceprints.lambda_handler"
  timeout = 20
  runtime = "python3.8"
  tags = {
    Name = "Rekognition-Faceprints"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}


#############################################################################################################################################################################
#                                                                      Resource Based Policy
#############################################################################################################################################################################

#Resource Based Policy for Lambda function to Allow S3 bucket to trigger it

resource "aws_lambda_permission" "s3-to-trigger-lambda" {
  function_name = aws_lambda_function.faceprints.function_name
  statement_id = "S3-to-trigger-Lambda"
  principal = "s3.amazonaws.com"
  action = "lambda:InvokeFunction"
  source_arn = var.source-s3-bucket-arn
}