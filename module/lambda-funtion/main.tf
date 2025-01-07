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