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