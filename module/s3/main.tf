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