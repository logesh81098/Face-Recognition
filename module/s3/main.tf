#############################################################################################################################################################################
#                                                                      S3 bucket
#############################################################################################################################################################################

# S3 bucket to store the source images

resource "aws_s3_bucket" "source-s3-bucket" {
  bucket = "face-rekognition-source-bucket"
  tags = {
    Name = "face-rekognition-source-bucket"
    Project = "Recognizing-faces-using-AWS-Rekognition-service"
  }
}

#############################################################################################################################################################################
#                                                                 S3 to trigger Lambda
#############################################################################################################################################################################

# S3 Object creation to trigger Lambda Function

resource "aws_s3_bucket_notification" "s3-to-trigger-lambda" {
  bucket = aws_s3_bucket.source-s3-bucket.bucket
  lambda_function {
    lambda_function_arn = var.faceprints-function-arn
    events = ["s3:ObjectCreated:*"]
  }
}