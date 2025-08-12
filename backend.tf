terraform {
  backend "s3" {
    bucket = "terraform-backend-files-logesh"
    key = "face-recognition"
    region = "us-east-1"
  }
}