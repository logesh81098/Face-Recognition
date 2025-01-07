#############################################################################################################################
#                                        Deploying S3 bucket 
#############################################################################################################################

#S3 bucket to store source images

resource "aws_s3_bucket" "source-image-s3" {
  bucket = "face-rekognition-source-bucket-logesh"
  tags = {
    Name = "face-rekognition-source-s3-bucket-logesh"
    Environment = "PROD"
  }
}

#############################################################################################################################
#                                      S3 bucket notication
#############################################################################################################################

#S3 to trigger lambda function for each getobject 

resource "aws_s3_bucket_notification" "s3-trigger-lambda" {
  bucket = aws_s3_bucket.source-image-s3.id
  lambda_function {
    lambda_function_arn = var.faceprints-lambda-arn
    events = ["s3:ObjectCreated:*"]
  }
}