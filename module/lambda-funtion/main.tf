#############################################################################################################################
#                                     Deploying Lambda function 
#############################################################################################################################

#Lambda function to create Rekognition collection ID
resource "aws_lambda_function" "face-rekognition-collection" {
  function_name = "face-rekognition-collection-id"
  handler = "face-rekognition-collection-id.lambda_handler"
  runtime = "python3.8"
  timeout = "20"
  role = var.lambda-to-create-collection-id
  filename = "module/lambda-funtion/face-rekognition-collection-id.zip"
  tags = {
    Name = "face-rekognition-collection-id"
  }
}



############################################################################################################################
#                                     Archive python code of Lambda function
############################################################################################################################
data "archive_file" "collection-id" {
  type = "zip"
  source_dir = "module/lambda-funtion"
  output_path = "module/lambda-funtion/face-rekognition-collection-id.zip"
}



#############################################################################################################################
#                                     Deploying Lambda function 
#############################################################################################################################

# Lambda function to collect faceprints from Rekognition service and store it in DynamoDB

resource "aws_lambda_function" "lambda-to-store-faceprints" {
  function_name = "faceprints"
  runtime = "python3.8"
  timeout = 20
  filename = "module/lambda-funtion/faceprints.zip"
  role = var.lambda-to-store-faceprints
  handler = "faceprints.lambda_handler"
  tags = {
    Name = "faceprints"
  }
}

resource "aws_lambda_permission" "s3-trigger-lambda" {
 statement_id = "InvokeLambdaFunction"
 principal = "s3.amazonaws.com"
 action = "lambda:InvokeFunction"
 source_arn = var.source-bucket-arn
  function_name = aws_lambda_function.lambda-to-store-faceprints.function_name
}


############################################################################################################################
#                                     Archive python code of Lambda function
############################################################################################################################
data "archive_file" "faceprints" {
  type = "zip"
  source_dir = "module/lambda-funtion"
  output_path = "module/lambda-funtion/faceprints.zip"
}


